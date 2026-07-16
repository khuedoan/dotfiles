import os
import subprocess

from kitty.boss import Boss
from kittens.tui.handler import result_handler

HOME = os.path.expanduser("~")
PROJECTS_DIR = os.path.join(HOME, "Projects")


def main(args: list[str]) -> str:
    listed = subprocess.run(
        ["zoxide", "query", "--list", "--base-dir", PROJECTS_DIR],
        capture_output=True,
        text=True,
    )
    projects = [
        path
        for path in listed.stdout.splitlines()
        if os.path.exists(os.path.join(path, ".git"))
    ]
    if not projects:
        return ""

    selected = subprocess.run(
        ["fzf", "--prompt", "project> ", "--layout=reverse"],
        input="\n".join(projects),
        capture_output=True,
        text=True,
    )
    return selected.stdout.strip()


@result_handler()
def handle_result(args: list[str], path: str, target_window_id: int, boss: Boss) -> None:
    if not path:
        return

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
