#!/usr/bin/env python3

import json
import os
import subprocess
import tempfile
from pathlib import Path

SCRIPT = Path(__file__).resolve().parents[2] / "bin" / "_workspace_prs"


def git(*args: str) -> None:
    subprocess.run(("git", *args), check=True, capture_output=True)


def make_repo(path: Path, branch: str, remote: str) -> None:
    git("init", "-q", "-b", branch, str(path))
    git("-C", str(path), "remote", "add", "origin", remote)


def main() -> None:
    with tempfile.TemporaryDirectory() as temporary:
        root = Path(temporary)
        worktrees = root / "worktrees"
        tickets = root / "tickets"
        cache = root / "cache"
        fake_bin = root / "bin"
        for path in (worktrees, tickets, fake_bin):
            path.mkdir()

        call_log = root / "gh-calls"
        fake_gh = fake_bin / "gh"
        fake_gh.write_text(
            "#!/usr/bin/env python3\n"
            "import json, os, sys\n"
            "args = sys.argv[1:]\n"
            "repo = args[args.index('--repo') + 1]\n"
            "with open(os.environ['GH_CALL_LOG'], 'a') as f: f.write(repo + '\\n')\n"
            "print(json.dumps(json.loads(os.environ['GH_RESPONSES']).get(repo, [])))\n"
        )
        fake_gh.chmod(0o755)

        ticket_root = tickets / "PROJECT-1-example"
        ticket_root.mkdir()
        (ticket_root / ".ticket").write_text("PROJECT-1")
        repo_a = ticket_root / "repo-a"
        repo_a2 = ticket_root / "repo-a-2"
        repo_b = ticket_root / "repo-b"
        make_repo(repo_a, "PROJECT-1/a", "git@github.com:acme/repo-a.git")
        make_repo(repo_a2, "PROJECT-1/a-2", "git@github.com:acme/repo-a.git")
        make_repo(repo_b, "PROJECT-1/b", "https://github.com/acme/repo-b.git")

        direct = worktrees / "direct"
        make_repo(direct, "feature/direct", "ssh://git@github.com/acme/repo-c")

        responses = {
            "acme/repo-a": [
                {"number": 11, "url": "https://github.com/acme/repo-a/pull/11", "headRefName": "PROJECT-1/a"},
                {"number": 12, "url": "https://github.com/acme/repo-a/pull/12", "headRefName": "PROJECT-1/a-2"},
                {"number": 99, "url": "https://github.com/acme/repo-a/pull/99", "headRefName": "other"},
            ],
            "acme/repo-b": [
                {"number": 22, "url": "https://github.com/acme/repo-b/pull/22", "headRefName": "PROJECT-1/b"},
            ],
            "acme/repo-c": [
                {"number": 33, "url": "https://github.com/acme/repo-c/pull/33", "headRefName": "feature/direct"},
            ],
        }
        env = {
            **os.environ,
            "PATH": f"{fake_bin}:{os.environ['PATH']}",
            "WORKTREE_DIR": str(worktrees),
            "TICKETS_DIR": str(tickets),
            "XDG_CACHE_HOME": str(cache),
            "GH_CALL_LOG": str(call_log),
            "GH_RESPONSES": json.dumps(responses),
        }

        def run(cwd: Path) -> list[dict]:
            output = subprocess.check_output((str(SCRIPT), str(cwd)), env=env, text=True)
            return json.loads(output)

        ticket_prs = run(repo_a)
        assert {pr["number"] for pr in ticket_prs} == {11, 12, 22}
        assert len(call_log.read_text().splitlines()) == 2

        assert run(repo_a) == ticket_prs
        assert len(call_log.read_text().splitlines()) == 2, "fresh cache should avoid gh"

        direct_prs = run(direct)
        assert [pr["number"] for pr in direct_prs] == [33]
        assert len(call_log.read_text().splitlines()) == 3

        assert run(root) == []

    print("workspace PR self-check passed")


if __name__ == "__main__":
    main()
