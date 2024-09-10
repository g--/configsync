function fish_title
  set title (_window_title)
  echo -ne "\x1b]1;$title\x1b\\";

end

function _window_title
  if git rev-parse --git-dir &> /dev/null
     set ROOT (git rev-parse --show-toplevel)
	 set repo_name (path basename $ROOT)
	 set branch_name (_branch_no_ticket)
	 if [ "$branch_name" = "HEAD" ]
		 echo -n "$repo_name: "
	 end
	 # echo -n "${ROOT##*/}: "
     echo -n (_branch_no_ticket)
  else
     echo -n "$PWD"
 end
end 

function _branch_no_ticket
  set BRANCH (_branch)
  if string match "/" "$BRANCH"
     echo -n $BRANCH | cut -f 2 -d "/"
  else
     echo -n $BRANCH
 end
end

function _branch
  if git rev-parse --git-dir &> /dev/null
     echo -n (git rev-parse --abbrev-ref HEAD)
  else
     echo -n ""
  end
end
