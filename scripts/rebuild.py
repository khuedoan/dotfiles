#!/usr/bin/env python3

import os
import shutil
import subprocess
import sys
import tempfile
import urllib.request


def run_installer(url: str, shell: str, env: dict[str, str] | None = None) -> None:
    with tempfile.NamedTemporaryFile(delete=False) as script:
        path = script.name

    try:
        with urllib.request.urlopen(url) as response:
            with open(path, "wb") as file:
                file.write(response.read())

        subprocess.run(
            [shell, path],
            check=True,
            env={**os.environ, **(env or {})},
        )
    finally:
        os.unlink(path)


def ensure_homebrew() -> None:
    if shutil.which("brew") is None:
        run_installer(
            "https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh",
            "bash",
            {"NONINTERACTIVE": "1"},
        )


def ensure_nix() -> None:
    binary = shutil.which("nix")
    if binary is None:
        run_installer("https://nixos.org/nix/install", "sh")


def main() -> None:
    match os.uname().sysname.lower():
        case "linux":
            command = ["nixos-rebuild", *sys.argv[1:]]
        case "darwin":
            ensure_homebrew()
            ensure_nix()
            command = [
                "/nix/var/nix/profiles/default/bin/nix",
                "--experimental-features", "nix-command flakes",
                "run",
                "nix-darwin/nix-darwin-25.11#darwin-rebuild",
                "--",
                *sys.argv[1:],
            ]
        case platform:
            raise SystemExit(f"unsupported platform: {platform}")

    os.execvp(command[0], command)


if __name__ == "__main__":
    main()
