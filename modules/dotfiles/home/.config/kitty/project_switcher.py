import json
import os
import subprocess

from kitty.boss import Boss
from kittens.tui.handler import result_handler

HOME = os.path.expanduser("~")
PROJECTS_DIR = os.path.join(HOME, "Projects")


def git_projects() -> list[str]:
    # zoxide tracks every directory you visit, frecency-ranked, so it doubles
    # as the project database: discovery, recency, and monorepo subfolders all
    # come for free. Keep only git repos; --base-dir scopes to ~/Projects and
    # unavailable directories are omitted by default.
    listed = subprocess.run(
        ["zoxide", "query", "--list", "--base-dir", PROJECTS_DIR],
        capture_output=True,
        text=True,
    )
    return [
        path
        for path in listed.stdout.splitlines()
        if os.path.exists(os.path.join(path, ".git"))
    ]


def open_project_paths() -> set[str]:
    # `boss` is only available in handle_result, so main queries open tabs over
    # remote control (kittens inherit KITTY_LISTEN_ON, so "kitty @" needs no --to).
    result = subprocess.run(["kitty", "@", "ls"], capture_output=True, text=True)
    if result.returncode != 0:
        return set()
    return {
        window["user_vars"]["project"]
        for os_window in json.loads(result.stdout)
        for tab in os_window["tabs"]
        for window in tab["windows"]
        if window.get("user_vars", {}).get("project")
    }


def main(args: list[str]) -> str:
    projects = git_projects()
    if not projects:
        return ""
    # zoxide already returns recency order, so floating open projects to the
    # front yields: open, then recent, then the rest.
    open_paths = open_project_paths()
    projects.sort(key=lambda p: p not in open_paths)
    by_label = {p.replace(HOME, "~", 1): p for p in projects}
    result = subprocess.run(
        ["fzf", "--prompt", "project> ", "--layout=reverse", "--height=100%"],
        input="\n".join(by_label),
        capture_output=True,
        text=True,
    )
    return by_label.get(result.stdout.strip(), "")


@result_handler()
def handle_result(args: list[str], path: str, target_window_id: int, boss: Boss) -> None:
    if not path:
        return
    # Iterate tabs directly rather than boss.match_tabs("var:..."): kitty's
    # search matcher raises on stale window weakrefs in long-lived sessions.
    for tab in boss.all_tabs:
        for window in tab.windows:
            if (window.user_vars or {}).get("project") == path:
                boss.set_active_tab(tab)
                return
    boss.launch(
        "--type=tab",
        f"--tab-title={os.path.basename(path)}",
        f"--var=project={path}",
        f"--cwd={path}",
    )
