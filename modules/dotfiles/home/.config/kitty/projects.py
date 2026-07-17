import os
import subprocess

from kitty.boss import Boss
from kittens.tui.handler import result_handler

# TODO explicit path because macOS GUI has minimal PATH
NIX_BIN = f"/etc/profiles/per-user/{os.environ.get('USER', '')}/bin"
PROJECTS_DIR = os.path.expanduser("~/Projects")
MAX_DEPTH = 2


def main(args: list[str]) -> str:
    zoxide = subprocess.Popen(
        [os.path.join(NIX_BIN, "zoxide"), "query", "--list", "--base-dir", PROJECTS_DIR],
        stdout=subprocess.PIPE,
        text=True,
    )
    fzf = subprocess.Popen(
        [os.path.join(NIX_BIN, "fzf"), "--prompt", "project> ", "--layout=reverse"],
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        text=True,
    )
    try:
        for line in zoxide.stdout:
            if line.count(os.sep) - PROJECTS_DIR.count(os.sep) > MAX_DEPTH:
                continue
            if os.path.exists(os.path.join(line.rstrip("\n"), ".git")):
                fzf.stdin.write(line)
        fzf.stdin.close()
    except BrokenPipeError:
        pass  # fzf exited before consuming the whole stream (e.g. Esc)

    return fzf.communicate()[0].strip()


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
