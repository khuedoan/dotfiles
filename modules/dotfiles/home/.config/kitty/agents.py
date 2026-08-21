"""Select an agent window. List agents that need user action first."""

import json
import os
import re
import subprocess
import traceback
from functools import cache

from kitty.boss import Boss
from kitty.constants import kitten_exe
from kittens.tui.handler import kitten_ui, result_handler

# macOS GUI applications start with a minimal PATH.
os.environ["PATH"] = os.pathsep.join(
    (
        f"/etc/profiles/per-user/{os.environ['USER']}/bin",
        "/run/current-system/sw/bin",
        "/usr/bin",
    )
)

AGENTS = {"pi", "codex"}
BLOCKED = re.compile(
    r"\[(?:y(?:es)?|n(?:o)?)/(?:y(?:es)?|n(?:o)?)\]"
    r"|\b(?:press|hit)\s+(?:enter|return)\b"
    r"|\b(?:enter|return)\s+to\s+(?:submit|confirm|accept|continue)\b"
    r"|\b(?:allow|approve|confirm)\b.*(?:\?|:)\s*$",
    re.IGNORECASE,
)
WORKING = re.compile(
    r"\b(?:esc|escape)\s+to\s+interrupt\b"
    r"|(?:\.\.\.|…)(?:\s+\([^)]*\))?\s*$",
    re.IGNORECASE,
)
STATE_STYLES = {
    "blocked": ("31", "◉"),
    "done": ("32", "●"),
    "working": ("33", "●"),
}


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
def git_branch(cwd: str) -> str:
    return subprocess.run(
        ["git", "-C", cwd, "branch", "--show-current"],
        capture_output=True,
        text=True,
    ).stdout.strip()


def detect_state(window_id: int) -> str:
    text = kitty(["get-text", "--match", f"id:{window_id}", "--extent", "screen"])
    lines = [
        line.strip()
        for line in text.splitlines()
        if any(character.isalnum() for character in line)
    ]
    if any(BLOCKED.search(line) for line in lines[-5:]) or any(
        line.endswith("?") for line in lines[-2:]
    ):
        return "blocked"
    if any(WORKING.search(line) for line in lines[-2:]):
        return "working"
    return "done"


def collect_agents(tabs: list[dict]) -> list[tuple[dict, str, str]]:
    agents = [
        (window, detect_state(window["id"]), agent)
        for tab in tabs
        for window in tab["windows"]
        if (agent := detect_agent(window)) is not None
    ]
    return sorted(agents, key=lambda item: item[1])


def format_row(window: dict, state: str, agent: str) -> str:
    color, symbol = STATE_STYLES[state]
    status = ansi(color, f"{symbol} {state}")
    cwd = window.get("cwd", "").rstrip(os.sep)
    project = ansi("1", os.path.basename(cwd) or window.get("title", ""))
    branch = git_branch(cwd)
    if branch:
        project += f" {ansi('2', '@ ' + branch)}"
    return f"{window['id']}\t{status}  {project}  {ansi('2', agent)}"


def pick_agent() -> str:
    [os_window] = json.loads(kitty(["ls"]))

    # Screen detection and previews need access to all Kitty windows.
    main.allow_indiscriminate_remote_control()
    agents = collect_agents(os_window["tabs"])
    fzf = subprocess.run(
        [
            "fzf",
            "--ansi",
            "--delimiter=\t",
            "--with-nth=2..",
            "--layout=reverse",
            "--info=hidden",
            "--no-hscroll",
            "--no-separator",
            "--no-scrollbar",
            "--prompt=agent> ",
            f"--preview={kitten_exe()} @ get-text --match=id:{{1}} --ansi",
            "--preview-window=up,follow",
        ],
        stdout=subprocess.PIPE,
        pass_fds=(main.rc_fd,),
        input="\n".join(format_row(*agent) for agent in agents),
        text=True,
    )

    return fzf.stdout.partition("\t")[0].strip()


@kitten_ui(allow_remote_control=True)
def main(args: list[str]) -> str:
    try:
        return pick_agent()
    except Exception:
        print(f"{traceback.format_exc()}\nPress Enter to close.")
        with open("/dev/tty", "rb", buffering=0) as tty:
            tty.read(1)
        return ""


@result_handler()
def handle_result(args: list[str], answer: str, target_window_id: int, boss: Boss) -> None:
    if answer:
        boss.set_active_window(boss.window_id_map[int(answer)])
