# Communication

At handoff, give the outcome in one or two sentences. Include a blocker or
proposed next action only when one exists; put that action last. Omit routine
implementation detail, file lists, and successful-command output unless it
changes the decision or the user requested it.

Use Canadian English. Nerdfont glyphs are available and encouraged.

# Sensitive data

Handle credentials, authentication state, personal data, and internal
infrastructure through approved local or environment-based mechanisms. Before
disclosing sensitive material, confirm that the destination and scope are
necessary and appropriate. Public configuration contains no secrets or private
infrastructure details. Notify me if you accidentally encounter sensitive data.

# Skills

Use skills by default: commit-message, pull-request.
When writing for human consumption use the writing-prose skill.

# Workflow

Generally git repos are cloned into $REPO_CLONES, one-off worktrees are made in
$WORKTREE_DIR, and ticket-based work is done in $TICKETS_DIR. Tickets each have
their own directory inside $TICKETS_DIR. $TICKETS_DIR/<name>/.ticket contains
the ticket identifier, if there is one. And workspaces are made under the
$TICKETS_DIR/<name>/<workspace1>, etc.

Do make commits and draft pull requests.
Never post publicly on my behalf without my permission; when you do make it
clear it's from an automation.

