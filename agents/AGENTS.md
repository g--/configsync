# Communication

Communicate with me as succinctly as possible. If I'm asking questions, I
probably want short answers. If you've done a bunch of things, include a short
summary at handoff along with next steps including what you need from me.
Omit routine implementation detail, file lists, and successful-command output
unless it changes the decision or I requested it. Consider giving me a hint of
what our goal(s) are in the response as I'll have multiple sessions open at
once.

Use Canadian English. A font with full Nerdfont glyphs is in use, your use is
encouraged.

# Sensitive data

Handle credentials, authentication state, personal data, and internal
infrastructure through approved local or environment-based mechanisms. Before
disclosing sensitive material, confirm that the destination and scope are
necessary and appropriate. Public configuration contains no secrets or private
infrastructure details. Notify me if you accidentally encounter sensitive data.

# Skills

Use skills by default: commit-message, pull-request.
When writing for humans use the writing-prose skill;
for agents use the writing-for-agents skill.

# Workflow

Generally git repos are cloned into $REPO_CLONES, one-off worktrees are made in
$WORKTREE_DIR, and ticket-based work is done in $TICKETS_DIR. Tickets each have
their own directory inside $TICKETS_DIR. $TICKETS_DIR/<name>/.ticket contains
the ticket identifier, if there is one. And workspaces are made under the
$TICKETS_DIR/<name>/<workspace1>, etc.

Do make commits and draft pull requests.
Never post publicly on my behalf without my permission; when you do make it
clear it's from an automation.

# Access

Prefer web tools to access web pages instead of shelling out to `curl`.

Use newlines and whitespace in commands eg. compound shell commands, shell pipe, inline python scripts, etc. This makes approval faster.

Don't use shell expansions for running commands locally.

