import os
import subprocess

from kitty.boss import Boss
from kittens.tui.handler import result_handler

HOME = os.path.expanduser("~")
PROJECTS_DIR = os.path.join(HOME, "Projects")

# GUI-launched kitty on macOS has a minimal PATH. Use `env -P` to search the Nix
# profile bin directory for the utility without polluting the shell env.
NIX_BIN = f"/etc/profiles/per-user/{os.environ.get('USER', '')}/bin"


def run(binary: str, *args: str) -> list[str]:
    return ["/usr/bin/env", "-P", NIX_BIN, binary, *args]


def main(args: list[str]) -> str:
    listed = subprocess.run(
        run("zoxide", "query", "--list", "--base-dir", PROJECTS_DIR),
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
        run("fzf", "--prompt", "project> ", "--layout=reverse"),
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
