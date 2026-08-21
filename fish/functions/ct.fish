function ct -d "cd into a ~/t ticket root, chosen via fzf"
  if not test -d $TICKETS_DIR
    echo "No tickets directory at $TICKETS_DIR"
    return 1
  end

  set -l roots $TICKETS_DIR/*/
  if test -z "$roots"
    echo "No ticket roots in $TICKETS_DIR"
    return 1
  end

  # Preview the ticket's Jira summary; the {} basename maps back to a root dir.
  set -l choice (
    for root in $roots
      path basename (string trim -r -c '/' -- $root)
    end | fzf --preview-label 'Ticket details' \
      --preview 'jira view (string replace -r -- "-.*" "" (echo {})) 2>/dev/null'
  )

  test -n "$choice"; or return 1
  cd $TICKETS_DIR/$choice
end
