# Claude Code adapter

`CLAUDE.md` imports the shared `../AGENTS.md` rules (see `../README.md`).

This directory also holds Claude Code assets with nothing ecobee-specific in them, linked into `~/.claude` on Geoff's workstation:

```sh
ln -s ~/.gsync/agents/claude/statusline.sh ~/.claude/statusline.sh
ln -s ~/.gsync/agents/claude/commands/note.md ~/.claude/commands/note.md
```

Company-specific Claude config (`settings.json`, the top-level `CLAUDE.md` entry point, and the `tf-upgrade` command) lives instead in `~/.esync/individual/geoff.o/claude`.
