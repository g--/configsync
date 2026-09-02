#!/usr/bin/env python3

import subprocess
import tempfile
from pathlib import Path

SCRIPT = Path(__file__).resolve().parents[2] / "bin" / "_ticket"


def run(cwd: Path) -> str:
    return subprocess.check_output((str(SCRIPT),), cwd=cwd, text=True)


def main() -> None:
    with tempfile.TemporaryDirectory() as temporary:
        root = Path(temporary)
        repo = root / "repo"
        subprocess.run(("git", "init", "-q", "-b", "PROJECT-1/change", str(repo)), check=True)
        assert run(repo) == "PROJECT-1"

        subprocess.run(("git", "-C", str(repo), "checkout", "-q", "-b", "main"), check=True)
        ticket_root = root / "ticket"
        workspace = ticket_root / "workspace"
        workspace.mkdir(parents=True)
        (ticket_root / ".ticket").write_text("PROJECT-2\n")
        assert run(workspace) == "PROJECT-2\n"
        assert run(root) == ""

    print("ticket helper self-check passed")


if __name__ == "__main__":
    main()
