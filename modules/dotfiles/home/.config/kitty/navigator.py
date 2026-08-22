"""Select projects, worktrees, and agent windows."""

import json
import os
import subprocess
import traceback
from collections.abc import Iterable
from difflib import SequenceMatcher
from functools import cache

from kitty.boss import Boss
from kitty.constants import kitten_exe
from kittens.tui.handler import kitten_ui, result_handler

PROJECTS_DIR = os.path.expanduser("~/Projects")
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
    "--no-hscroll",
    "--no-separator",
    "--no-scrollbar",
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
WORKING_PHRASES = (
    "Working...",
    "esc to interrupt",
)
STATE_STYLES = {
    "blocked": ("31", "●"),
    "done": ("32", "✓"),
    "working": ("33", "◉"),
}


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


def open_project(boss: Boss, path: str) -> None:
    for tab in boss.all_tabs:
        if any((window.user_vars or {}).get("project") == path for window in tab.windows):
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


def pick_project() -> str:
    zoxide = subprocess.run(
        ["zoxide", "query", "--list", "--base-dir", PROJECTS_DIR],
        capture_output=True,
        check=True,
        env=command_env(),
        text=True,
    )
    paths = (path for path in zoxide.stdout.splitlines() if is_project(path))
    result = fzf(
        (os.path.expanduser("~"), *paths),
        "--prompt=project> ",
        "--preview=bat --color=always --style=plain -- {}/README.md",
    )
    return result.stdout.strip()


def pause(message: str) -> None:
    print(f"{message}\n\nPress Enter to continue.")
    with open("/dev/tty", "rb", buffering=0) as tty:
        tty.read(1)


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
    color, symbol = STATE_STYLES[state]
    status = ansi(color, symbol)
    cwd = window.get("cwd", "").rstrip(os.sep)
    project, branch = git_context(cwd)
    project = ansi(color, project or os.path.basename(cwd) or window.get("title", ""))
    if branch:
        project += f" {ansi('2', '@ ' + branch)}"
    return f"{window['id']}\t{status} {project} {ansi('2', agent)}"


def pick_agent() -> str:
    [os_window] = json.loads(kitty(["ls"]))
    main.allow_indiscriminate_remote_control()
    agents = collect_agents(os_window["tabs"])
    result = fzf(
        (format_agent(*agent) for agent in agents),
        "--ansi",
        "--delimiter=\t",
        "--with-nth=2..",
        "--prompt=agent> ",
        f"--preview={kitten_exe()} @ get-text --match=id:{{1}} --ansi",
        "--preview-window=up,follow",
        pass_fds=(main.rc_fd,),
    )
    return result.stdout.partition("\t")[0].strip()


PICKERS = {
    "agents": pick_agent,
    "projects": pick_project,
}


@kitten_ui(allow_remote_control=True)
def main(args: list[str]) -> str:
    try:
        return PICKERS[args[1]]()
    except Exception:
        pause(traceback.format_exc())
        return ""


@result_handler()
def handle_result(args: list[str], answer: str, target_window_id: int, boss: Boss) -> None:
    if not answer:
        return
    if args[1] == "agents":
        boss.set_active_window(boss.window_id_map[int(answer)])
    else:
        open_project(boss, answer)
