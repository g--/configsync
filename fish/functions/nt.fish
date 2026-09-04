function nt -d "Create (or reuse) a ~/t ticket root and cd into it"
  if test (count $argv) -lt 1
    echo "usage: nt <ticket_id> [slug]"
    return 1
  end

  set -l ticket $argv[1]
  set -l slug

  if test (count $argv) -ge 2
    set slug $argv[2]
  else
    # Derive the slug from the Jira summary, matching the `branchname`
    # jira template: lowercase, non-alphanumerics collapsed to single '-'.
    set -l summary (jira view $ticket --template title 2>/dev/null | string collect | string trim)
    if test -n "$summary"
      set slug (string lower -- $summary | string replace -r -a '[^a-z0-9]+' '-' | string trim -c '-')
    end
  end

  set -l dirname $ticket
  if test -n "$slug"
    set dirname "$ticket-$slug"
  end

  set -l root $TICKETS_DIR/$dirname
  if not test -d $root
    mkdir -p $root; or return 1
    echo $ticket > $root/.ticket
    echo "Created ticket root $root"
  else
    echo "Reusing ticket root $root"
  end

  cd $root
end

if set -q JIRA_BASE
  complete -c nt -n "test (count (commandline -opc)) -eq 1" -a "(_choose_jira_ticket | string trim -r -c /)" -f
end
