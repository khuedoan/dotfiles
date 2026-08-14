"""Select a pi agent window. List agents that need attention first."""

import json
import os
import subprocess
import traceback

from kitty.boss import Boss
from kitty.constants import kitten_exe
from kittens.tui.handler import kitten_ui, result_handler

# TODO explicit path because macOS GUI has minimal PATH
FZF = f"/etc/profiles/per-user/{os.environ['USER']}/bin/fzf"

STATE_COLORS = {"done": "32", "working": "33", "idle": "90"}
STATE_RANK = {state: rank for rank, state in enumerate(STATE_COLORS)}
CYAN = "36"


def ansi(color: str, text: str) -> str:
    return f"\x1b[{color}m{text}\x1b[0m"


def is_alive(pid: str) -> bool:
    try:
        os.kill(int(pid), 0)
    except (ProcessLookupError, ValueError):
        return False
    return True


def kitty(args: list[str]) -> str:
    result = main.remote_control(args, capture_output=True)
    if result.returncode != 0:
        error = result.stderr.decode().strip()
        raise RuntimeError(f"kitten @ {' '.join(args)} failed: {error}")
    return result.stdout.decode()


def collect_agents(tabs: list[dict]) -> list[tuple[dict, dict]]:
    agents = [
        (tab, window)
        for tab in tabs
        for window in tab["windows"]
        if window["user_vars"].get("pi_state") in STATE_COLORS
        and is_alive(window["user_vars"].get("pi_pid", ""))
    ]
    return sorted(
        agents,
        key=lambda agent: STATE_RANK[agent[1]["user_vars"]["pi_state"]],
    )


def format_row(tab: dict, window: dict) -> str:
    status = window["user_vars"]
    state = status["pi_state"]
    return (
        f"{window['id']}\t{ansi(STATE_COLORS[state], state)}  "
        f"{tab['title']}  {ansi(CYAN, status['pi_title'])}"
    )


def pick_agent() -> str:
    [os_window] = json.loads(kitty(["ls", "--match", "state:focused_os_window"]))
    tabs = os_window["tabs"]
    agents = collect_agents(tabs)

    # Screen previews require access to all kitty windows.
    main.allow_indiscriminate_remote_control()
    previous_layout = next(tab["layout"] for tab in tabs if tab["is_active"])
    kitty(["goto-layout", "stack"])
    try:
        fzf = subprocess.run(
            [
                FZF,
                "--ansi",
                "--delimiter=\t",
                "--with-nth=2..",
                "--layout=reverse",
                "--prompt=agent> ",
                f"--preview={kitten_exe()} @ get-text --match=id:{{1}} --ansi",
            ],
            input="\n".join(format_row(tab, window) for tab, window in agents),
            stdout=subprocess.PIPE,
            pass_fds=(main.rc_fd,),
            text=True,
        )
    finally:
        kitty(["goto-layout", previous_layout])

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
