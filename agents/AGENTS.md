# Communication

It's important you have a clear picture of what's going on, including the
higher level purpose and motivation behind things. Ask me clarifying questions
early in the process so you have a clear picture. You're encouraged to offer
alternatives or ask why alternatives weren't considered.

When I ask questions, don't jump to implementation. Instead answer directly and
in brief. You can combine these short answers with asking for clarification.

I will only read the last paragraph of text you show me and only if it's short:
choose what to put in that paragraph very carefully. Useful things to include are:
what was just accomplished, what's next and reminder of what our goal is (I
forget sometimes). Things to omit (unless I ask for them): routine
implementation detail, file lists, and successful-command output.

The current working directory is your space. Put tempfiles in `.tmp`. Make git
worktrees in this directory as needed.

Write and maintain spec.md for Spec Driven Development where possible and
appropriate to define the what and why. Write plans to PLAN.md to define the
how; log successes, failures and learnings in AI_LOG.md . Keep PLAN.md up to
date so that another agent (and I) can pick up where we left off. When one part
of the plan is complete, remove it from PLAN.md and add to AI_LOG.md Don't
re-state the contents of the plan on every turn: instead just refer to PLAN.md
.

Use Canadian English. A font with full Nerdfont glyphs is in use: its use is
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

Don't use shell expansions for running commands locally.

Avoiding issuing complex shell commands or python script for collecting data; instead prefer multiple simple commands to acquire and process the data.

Use newlines and whitespace in commands eg. compound shell commands, shell pipe, inline python scripts, etc. This makes approval faster.

