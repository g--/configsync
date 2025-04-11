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
	 # possible generic? $(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')
	 else if [ "$branch_name" = "main" ]
		 echo -n "$repo_name: "
	 else
		 echo -n (string shorten -m 6 $repo_name)": "
	 end
     echo -n $branch_name
  else
     echo -n "$PWD"
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
     echo -n (git rev-parse --abbrev-ref HEAD)
  else
     echo -n ""
  end
end
