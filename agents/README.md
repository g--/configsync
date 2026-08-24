# Shared Agent Instructions

`AGENTS.md` is the common source of cross-harness guidance. Keep it portable:
no personal preferences that only apply to one harness, credentials, private
hosts, internal URLs, or machine inventory.

Each harness gets an adapter file that imports the shared rules and can carry
its own additions. The current Claude adapter is `claude/CLAUDE.md`; OpenCode
loads `AGENTS.md` directly and its own additions from `opencode/OPENCODE.md`.
