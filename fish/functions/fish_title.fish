function fish_title
  set title (_window_title)
  echo -ne "\x1b]1;$title\x1b\\";

end

function _window_title
  if git rev-parse --git-dir &> /dev/null
     set ROOT (git rev-parse --show-toplevel)
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
