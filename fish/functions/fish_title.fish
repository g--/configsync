function fish_title
  set title (_window_title)
  echo -ne "\x1b]1;$title\x1b\\";
  # Stash title as a WezTerm user var so format-tab-title can use it
  # even when another process (e.g. Claude Code) overwrites the pane title
  printf "\033]1337;SetUserVar=%s=%s\007" fish_title (printf '%s' "$title" | base64)

end

function _window_title
  if git rev-parse --git-dir &> /dev/null
     set ROOT (git rev-parse --show-toplevel)
	 set repo_name (path basename $ROOT)
	 set BRANCH (_branch)
	 set branch_suffix (_branch_no_ticket)
	 set ticket (string match -r "^([^/]+)/" "$BRANCH")[2]
	 if [ "$branch_suffix" = "HEAD" -o "$branch_suffix" = "main" ]
		 echo -n "$repo_name: $branch_suffix"
	 else if test -n "$ticket"
		 echo -n "$branch_suffix ($ticket, $repo_name)"
	 else
		 echo -n "$branch_suffix ($repo_name)"
	 end
  else
     echo -n (path basename $PWD)" ($PWD)"
 end
end 

function _branch_no_ticket
  set BRANCH (_branch)
  if set results (string match -r "/(.*)" "$BRANCH")
     echo -n $results[2]
  else
     echo -n $BRANCH
 end
end

function _branch
  if git rev-parse --git-dir &> /dev/null
     echo -n (git rev-parse --abbrev-ref HEAD 2>/dev/null)
  else
     echo -n ""
  end
end
