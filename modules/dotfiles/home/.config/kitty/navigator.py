"""Select projects, worktrees, and agent windows."""

import json
import os
import subprocess
import traceback
from collections.abc import Iterable
from difflib import SequenceMatcher
from functools import cache
from urllib.parse import quote

from kitty.boss import Boss
from kitty.constants import kitten_exe
from kittens.tui.handler import kitten_ui, result_handler

PROJECTS_DIR = os.path.expanduser("~/Projects")
WORKTREES_DIR = os.path.join(PROJECTS_DIR, ".worktrees")
MAX_PROJECT_DEPTH = 2
COMMAND_PATH = os.pathsep.join(
    (
        f"/etc/profiles/per-user/{os.environ['USER']}/bin",
        "/run/current-system/sw/bin",
        "/usr/bin",
    )
)
FZF_STYLE = (
    "fzf",
    "--layout=reverse",
    "--info=hidden",
    "--preview-window=up",
)
AGENTS = {"pi", "codex"}
BLOCKED_PHRASES = (
    "yes no",
    "enter select",
    "enter to",
    "do you want",
    "would you like",
    "which option",
    "which approach",
    "should i proceed",
    "need your",
    "allow",
    "approve",
    "confirm",
)
WORKING_PHRASES = ("working", "esc to interrupt")
STYLES = {
    "blocked": ("31", ""),
    "done": ("32", ""),
    "working": ("33", ""),
    "open-project": ("32", ""),
    "project": ("2", ""),
    "worktree": ("35", ""),
}


def navigation_row(value: str, label: str, style: str) -> str:
    color, symbol = STYLES[style]
    return f"{value}\t{ansi(color, symbol + '  ')}{label}"


def command_env() -> dict[str, str]:
    return os.environ | {"PATH": COMMAND_PATH}


def fzf(
    rows: Iterable[str], *options: str, pass_fds: tuple[int, ...] = ()
) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        [*FZF_STYLE, *options],
        env=command_env(),
        input="\n".join(rows),
        pass_fds=pass_fds,
        stdout=subprocess.PIPE,
        text=True,
    )


def select_item(
    rows: Iterable[str],
    *options: str,
    keys: tuple[str, ...] = (),
    pass_fds: tuple[int, ...] = (),
) -> tuple[str, str]:
    key_options = (f"--expect={','.join(keys)}",) if keys else ()
    result = fzf(
        rows,
        "--ansi",
        "--delimiter=\t",
        "--with-nth=2..",
        *key_options,
        *options,
        pass_fds=pass_fds,
    )
    key, _, row = result.stdout.partition("\n")
    if not keys:
        key, row = "", key
    return key, row.partition("\t")[0].rstrip("\n")


def git(
    *args: str, cwd: str | None = None, check: bool = True
) -> subprocess.CompletedProcess[str]:
    command = ["git"]
    if cwd:
        command.extend(("-C", cwd))
    return subprocess.run(
        [*command, *args],
        capture_output=True,
        check=check,
        env=command_env(),
        text=True,
    )


def project_name(root: str) -> str:
    parts = os.path.relpath(root, PROJECTS_DIR).split(os.sep)
    if parts[0] == ".worktrees":
        parts = parts[1:-1]
    return os.path.join(*parts)


def worktree_path(main_path: str, branch: str) -> str:
    projects_dir = os.path.realpath(PROJECTS_DIR)
    main_path = os.path.realpath(main_path)
    if os.path.commonpath((projects_dir, main_path)) != projects_dir:
        raise ValueError(f"Repository is outside {PROJECTS_DIR}: {main_path}")

    project = os.path.relpath(main_path, projects_dir)
    return os.path.join(WORKTREES_DIR, project, quote(branch, safe="-._"))


def open_project(boss: Boss, path: str) -> None:
    path = os.path.realpath(path)
    for tab in boss.all_tabs:
        if any(
            os.path.realpath(project) == path
            for window in tab.windows
            if (project := (window.user_vars or {}).get("project"))
        ):
            boss.set_active_tab(tab)
            return

    boss.launch(
        "--type=tab",
        f"--tab-title={os.path.basename(path)}",
        f"--var=project={path}",
        f"--cwd={path}",
    )


def is_project(path: str) -> bool:
    parts = os.path.relpath(path, PROJECTS_DIR).split(os.sep)
    return (
        len(parts) <= MAX_PROJECT_DEPTH
        and not any(part.startswith(".") for part in parts)
        and os.path.exists(os.path.join(path, ".git"))
    )


def open_projects() -> set[str]:
    return {
        os.path.realpath(project)
        for os_window in json.loads(kitty(["ls"]))
        for tab in os_window["tabs"]
        for window in tab["windows"]
        if (project := (window.get("user_vars") or {}).get("project"))
    }


def pick_project() -> tuple[str, str] | None:
    zoxide = subprocess.run(
        ["zoxide", "query", "--list", "--base-dir", PROJECTS_DIR],
        capture_output=True,
        check=True,
        env=command_env(),
        text=True,
    )
    paths = [
        os.path.expanduser("~"),
        *(path for path in zoxide.stdout.splitlines() if is_project(path)),
    ]
    opened = open_projects()
    _, path = select_item(
        (
            navigation_row(
                path,
                "~"
                if path == os.path.expanduser("~")
                else os.path.relpath(path, PROJECTS_DIR),
                "open-project" if os.path.realpath(path) in opened else "project",
            )
            for path in paths
        ),
        "--prompt=project> ",
        "--preview=bat --color=always --style=plain -- {1}/README.md",
    )
    return ("project", path) if path else None


def worktrees(cwd: str) -> list[dict[str, str]]:
    output = git("worktree", "list", "--porcelain", cwd=cwd).stdout.strip()
    if not output:
        return []
    return [
        dict(line.partition(" ")[::2] for line in block.splitlines())
        for block in output.split("\n\n")
    ]


def format_worktree(entry: dict[str, str]) -> str:
    path = entry["worktree"]
    branch = entry.get("branch", "").removeprefix("refs/heads/")
    state = branch or f"detached at {entry.get('HEAD', '')[:8]}"
    if "locked" in entry:
        state += " [locked]"
    if "prunable" in entry:
        state += " [prunable]"
    return f"{project_name(path)} {ansi('2', '@ ' + state)}"


def select_branch(main_path: str, entries: list[dict[str, str]]) -> tuple[str, bool]:
    checked_out = {
        entry.get("branch", "").removeprefix("refs/heads/") for entry in entries
    }
    branches = git(
        "for-each-ref", "--format=%(refname:short)", "refs/heads", cwd=main_path
    ).stdout.splitlines()
    result = fzf(
        (branch for branch in branches if branch not in checked_out),
        "--print-query",
        "--prompt=branch> ",
        "--header=select an existing branch or type a new branch",
    )
    if result.returncode == 130:
        return "", False
    lines = result.stdout.splitlines()
    branch = lines[-1].strip() if lines else ""
    return branch, branch in branches


def add_worktree(main_path: str, entries: list[dict[str, str]]) -> str:
    branch, exists = select_branch(main_path, entries)
    if not branch:
        return ""

    path = worktree_path(main_path, branch)
    os.makedirs(os.path.dirname(path), exist_ok=True)
    args = ("worktree", "add", path, branch)
    if not exists:
        args = ("worktree", "add", "-b", branch, path)
    git(*args, cwd=main_path)
    return path


def pause(message: str) -> None:
    print(f"{message}\n\nPress Enter to continue.")
    with open("/dev/tty", "rb", buffering=0) as tty:
        tty.read(1)


def confirm_remove(path: str, reason: str) -> bool:
    result = fzf(
        (path,),
        f"--prompt=remove {os.path.basename(path)}? ",
        f"--header={reason}\npress enter to force removal or escape to cancel",
        "--preview=git -C {} -c color.status=always status --short --branch",
    )
    return bool(result.stdout.strip())


def remove_worktree(main_path: str, entry: dict[str, str]) -> bool:
    path = entry["worktree"]
    if path == main_path:
        pause("The main worktree cannot be removed.")
        return False
    if "prunable" in entry:
        git("worktree", "remove", "--force", "--force", path, cwd=main_path)
        return True

    try:
        git("worktree", "remove", path, cwd=main_path)
    except subprocess.CalledProcessError as error:
        if not confirm_remove(path, error.stderr.strip()):
            return False
        git("worktree", "remove", "--force", "--force", path, cwd=main_path)
    return True


def pick_worktree() -> tuple[str, str] | None:
    repository = git("rev-parse", "--show-toplevel", check=False)
    if repository.returncode != 0:
        return None
    entries = worktrees(repository.stdout.strip())
    if not entries:
        return None
    main_path = entries[0]["worktree"]

    while True:
        entries = worktrees(main_path)
        key, path = select_item(
            (
                navigation_row(entry["worktree"], format_worktree(entry), "worktree")
                for entry in entries
            ),
            "--prompt=worktree> ",
            "--header=ctrl-a: add  ctrl-x: remove",
            "--preview=git -C {1} -c color.status=always status --short --branch",
            keys=("ctrl-a", "ctrl-x"),
        )

        try:
            match key, path:
                case "ctrl-a", _:
                    if path := add_worktree(main_path, entries):
                        return "worktree", path
                case "ctrl-x", path if path:
                    entry = next(
                        entry for entry in entries if entry["worktree"] == path
                    )
                    if remove_worktree(main_path, entry):
                        return "removed", path
                case "", path:
                    return ("worktree", path) if path else None
        except subprocess.CalledProcessError as error:
            pause(error.stderr.strip() or str(error))


def ansi(color: str, text: str) -> str:
    return f"\x1b[{color}m{text}\x1b[0m"


def kitty(args: list[str]) -> str:
    result = main.remote_control(args, capture_output=True)
    if result.returncode != 0:
        error = result.stderr.decode().strip()
        raise RuntimeError(f"kitten @ {' '.join(args)} failed: {error}")
    return result.stdout.decode()


def detect_agent(window: dict) -> str | None:
    for process in window.get("foreground_processes", []):
        command = process.get("cmdline", [])
        if not command:
            continue
        agent = os.path.basename(command[0]).removeprefix(".").removesuffix("-wrapped")
        if agent in AGENTS:
            return agent
    return None


@cache
def git_context(cwd: str) -> tuple[str, str]:
    result = git(
        "rev-parse",
        "--show-toplevel",
        "--abbrev-ref",
        "HEAD",
        cwd=cwd,
        check=False,
    )
    if result.returncode != 0:
        return "", ""

    root, branch = result.stdout.splitlines()
    return project_name(root), "" if branch == "HEAD" else branch


def fuzzy_match(text: str, phrases: tuple[str, ...], threshold: float = 0.88) -> bool:
    words = "".join(
        character if character.isalnum() else " " for character in text.casefold()
    ).split()
    for phrase in phrases:
        word_count = len(phrase.split())
        windows = (
            " ".join(words[start : start + word_count])
            for start in range(max(1, len(words) - word_count + 1))
        )
        if any(
            SequenceMatcher(None, phrase, window).ratio() >= threshold
            for window in windows
        ):
            return True
    return False


def detect_state(window_id: int) -> str:
    screen = kitty(["get-text", "--match", f"id:{window_id}", "--extent", "screen"])
    recent_lines = [
        line.strip()
        for line in screen.splitlines()
        if any(character.isalnum() for character in line)
    ][-5:]

    for state, phrases in (
        ("blocked", BLOCKED_PHRASES),
        ("working", WORKING_PHRASES),
    ):
        if any(fuzzy_match(line, phrases) for line in recent_lines):
            return state

    return "done"


def collect_agents(tabs: list[dict]) -> list[tuple[dict, str, str]]:
    agents = [
        (window, detect_state(window["id"]), agent)
        for tab in tabs
        for window in tab["windows"]
        if (agent := detect_agent(window)) is not None
    ]
    return sorted(agents, key=lambda item: item[1])


def format_agent(window: dict, state: str, agent: str) -> str:
    color, _ = STYLES[state]
    cwd = window.get("cwd", "").rstrip(os.sep)
    project, branch = git_context(cwd)
    project = ansi(color, project or os.path.basename(cwd) or window.get("title", ""))
    if branch:
        project += f" {ansi('2', '@ ' + branch)}"
    return f"{project} {ansi('2', agent)}"


def pick_agent() -> tuple[str, str] | None:
    [os_window] = json.loads(kitty(["ls"]))
    main.allow_indiscriminate_remote_control()
    _, window_id = select_item(
        (
            navigation_row(
                str(window["id"]),
                format_agent(window, state, agent),
                state,
            )
            for window, state, agent in collect_agents(os_window["tabs"])
        ),
        "--prompt=agent> ",
        f"--preview={kitten_exe()} @ get-text --match=id:{{1}} --ansi",
        "--preview-window=up,follow",
        pass_fds=(main.rc_fd,),
    )
    return ("agent", window_id) if window_id else None


PICKERS = dict(agents=pick_agent, projects=pick_project, worktrees=pick_worktree)


@kitten_ui(allow_remote_control=True)
def main(args: list[str]) -> str:
    try:
        result = PICKERS[args[1]]()
        return json.dumps(result) if result else ""
    except Exception:
        pause(traceback.format_exc())
        return ""


@result_handler()
def handle_result(args: list[str], answer: str, target_window_id: int, boss: Boss) -> None:
    if not answer:
        return
    selector, selection = json.loads(answer)
    match selector:
        case "agent":
            boss.set_active_window(boss.window_id_map[int(selection)])
        case "removed":
            for tab in tuple(boss.all_tabs):
                if any(
                    (window.user_vars or {}).get("project") == selection
                    for window in tab.windows
                ):
                    boss.close_tab(tab)
        case "project" | "worktree":
            open_project(boss, selection)
        case _:
            raise ValueError(f"Unknown navigator result: {selector}")
