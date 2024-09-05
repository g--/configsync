
function gamend 
	_there_is_a_commit_to_amend && git commit -a --amend --no-edit $argv
end

function gmessage
	_there_is_a_commit_to_amend && git commit --amend $argv
end

function gpush
	_on_a_branch && rebase && git push --force $argv
end

function rebase_interactive
  set BASE (git merge-base (_main) HEAD)
  git rebase -i $BASE
end


function gdiff
  set BASE (git merge-base (_main) HEAD)
  git diff $BASE..HEAD
end

function ghg 
	gh search code --owner $GITHUB_ORG
end

function nb
  if [ "{$argv[1]}" = "" ]
    echo "usage: nb <branchname>"
    return
  end
  set branchname $argv[1]

  if [ "{$argv[2]}" = "" ]
     set MAIN (_main)
  else
     set MAIN $argv[2]
  end

  if not git fetch
    echo "Error: 'git fetch' failed"
    return 1
  end
  if not git checkout -b $branchname $MAIN
    echo "Error: 'git checkout -b $branchname $MAIN' failed"
    return 1
  end
  if not git push --set-upstream origin $branchname
    echo "Error: 'git push --set-upstream origin $branchname' failed"
    return 1
  end
end

function rebase
  git fetch
  git rebase (_main)
end

function main
  git fetch
  git checkout (_main)
end


function _there_is_a_commit_to_amend
  if not git diff-index --quiet (_main)
    return 0
  else
    echo "There is no commit on this branch yet."
    return 1
  end
end

function _on_a_branch
  set CURRENT (git branch --show-current)
  set MAIN (git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')
  if [ "$CURRENT" = "$MAIN" ]
    echo "The current branch is $MAIN, which is the main branch for this repo."
    return 1
  else if [ (git rev-parse --abbrev-ref --symbolic-full-name HEAD) = "HEAD" ]
    echo "Currently on a detached head."
    return 1
  else
    return 0
  end
end


function _main
  command git rev-parse --abbrev-ref origin/HEAD
end


