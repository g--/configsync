set -xU GITHUB_USER 'g--'


function gamend 
	_there_is_a_commit_to_amend && git commit -a --amend --no-edit $argv
end

function gmessage
	_there_is_a_commit_to_amend && git commit --amend $argv
end

function force_push
	_on_a_branch && rebase && git push --force $argv
end

function rebase_interactive
  set BASE (git merge-base (_main) HEAD)
  git rebase -i $BASE
end


function gdiff
  set BASE (git merge-base (_main) HEAD)
  git diff $argv $BASE..HEAD
end

function ghg 
	gh search code --owner $GITHUB_ORG
end

function nb
  if not count argv
    echo "usage: nb <branchname>"
    return
  end

  set branchname $argv[1]

  if [ (count $argv) = "2" ]
     set MAIN $argv[2]
  else
     set MAIN (_main)
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

  echo "created branch $branchname from $MAIN"
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

set -gx REPO_CLONES ~/d
set -gx WORKTREE_DIR ~/w

# Shared helpers for worktree commands

function _wt_repo_name -d "Extract repo name from SSH URL"
  string replace -r '.*/' '' -- $argv[1] | string replace -r '\.git$' ''
end

function _wt_ensure_clone -d "Clone or fetch a repo, prints clone_dir"
  set -l repo_url $argv[1]
  set -l repo_name (_wt_repo_name $repo_url)
  set -l clone_dir $REPO_CLONES/$repo_name

  if not test -d $clone_dir
    echo "Cloning $repo_url into $clone_dir..." >&2
    if not git clone $repo_url $clone_dir
      echo "Error: git clone failed" >&2
      return 1
    end
  else
    echo "Fetching in $clone_dir..." >&2
    if not git -C $clone_dir fetch
      echo "Error: git fetch failed" >&2
      return 1
    end
  end

  echo $clone_dir
end

function _wt_path -d "Compute worktree path from repo name and branch"
  set -l repo_name $argv[1]
  set -l branchname $argv[2]

  set -l parts (string split '/' -- $branchname)
  set -l worktree_name
  if test (count $parts) -ge 2
    set worktree_name $parts[1]__{$repo_name}__(string join '_' -- $parts[2..])
  else
    set worktree_name {$branchname}__{$repo_name}
  end

  echo $WORKTREE_DIR/$worktree_name
end

function nw -d "Clone (or fetch) a repo and create a worktree with a new branch"
  if test (count $argv) -lt 2
    echo "usage: nw <repo> <ticket_id/branch_suffix>"
    return 1
  end

  set -l repo_url $argv[1]
  set -l branchname $argv[2]
  set -l repo_name (_wt_repo_name $repo_url)
  set -l clone_dir (_wt_ensure_clone $repo_url) || return 1
  set -l worktree_path (_wt_path $repo_name $branchname)
  set -l main_branch (git -C $clone_dir rev-parse --abbrev-ref origin/HEAD)

  if not git -C $clone_dir worktree add -b $branchname $worktree_path $main_branch
    echo "Error: git worktree add failed"
    return 1
  end

  if not git -C $worktree_path push --set-upstream origin $branchname
    echo "Error: git push --set-upstream failed"
    return 1
  end

  echo "Worktree ready at $worktree_path"
  cd $worktree_path
end

function cw -d "Check out an existing remote branch into a worktree"
  if test (count $argv) -lt 2
    echo "usage: cw <repo> <branch>"
    return 1
  end

  set -l repo_url $argv[1]
  set -l branchname $argv[2]
  set -l repo_name (_wt_repo_name $repo_url)
  set -l clone_dir (_wt_ensure_clone $repo_url) || return 1
  set -l worktree_path (_wt_path $repo_name $branchname)

  # Use existing local branch if it exists, otherwise create tracking branch
  if git -C $clone_dir show-ref --verify --quiet refs/heads/$branchname
    if not git -C $clone_dir worktree add $worktree_path $branchname
      echo "Error: git worktree add failed"
      return 1
    end
  else
    if not git -C $clone_dir worktree add --track -b $branchname $worktree_path origin/$branchname
      echo "Error: git worktree add failed"
      return 1
    end
  end

  echo "Worktree ready at $worktree_path"
  cd $worktree_path
end

function cr -d "Check out a GitHub PR into a worktree"
  if test (count $argv) -eq 0
    echo "usage: cr <pr-url>"
    return 1
  end

  set -l pr_url $argv[1]

  # Extract owner/repo/number from URL like https://github.com/org/repo/pull/123
  set -l match (string match -r 'github\.com/([^/]+)/([^/]+)/pull/(\d+)' -- $pr_url)
  if test -z "$match"
    echo "Error: could not parse PR URL '$pr_url'"
    return 1
  end

  set -l owner $match[2]
  set -l repo $match[3]
  set -l pr_number $match[4]

  set -l pr_json (gh pr view $pr_number --repo $owner/$repo --json headRefName,headRepositoryOwner,headRepository 2>&1)
  if test $status -ne 0
    echo "Error: could not fetch PR details"
    echo $pr_json
    return 1
  end

  set -l branch (echo $pr_json | jq -r '.headRefName')
  set -l head_owner (echo $pr_json | jq -r '.headRepositoryOwner.login')
  set -l head_repo (echo $pr_json | jq -r '.headRepository.name')

  if test -z "$branch" -o "$branch" = null -o -z "$head_owner" -o "$head_owner" = null
    echo "Error: could not parse PR details"
    return 1
  end

  set -l repo_url "git@github.com:$head_owner/$head_repo.git"
  cw $repo_url $branch
end

if set -q JIRA_BASE
	complete -c nb -a "(_choose_jira_ticket)" -f

	function _choose_jira_ticket
		set ticket (jira now_as_branch_name | fzf --preview-label 'Ticket details' --preview 'jira view (echo {} | string split /)[1]' | string split / )
		echo "$ticket[1]/"
	end

	# nw: arg 2 is branch name via jira ticket picker (same as nb)
	complete -c nw -n "test (count (commandline -opc)) -eq 2" -a "(_choose_jira_ticket)" -f
end

# cw: arg 2 is an existing remote branch, picked via fzf
function _choose_remote_branch
	set -l tokens (commandline -opc)
	set -l repo_url $tokens[2]
	set -l repo_name (_wt_repo_name $repo_url)
	set -l clone_dir $REPO_CLONES/$repo_name
	if not test -d $clone_dir
		return
	end
	git -C $clone_dir branch -r --format '%(refname:short)' | string replace 'origin/' '' | grep -v HEAD | fzf
end
complete -c cw -n "test (count (commandline -opc)) -eq 2" -a "(_choose_remote_branch)" -f

if set -q GITHUB_ORG
	complete -c git -n "__fish_seen_subcommand_from clone" -a "(repo_list_for_org | fzf)" -f

	# nw/cw: arg 1 is repo via org repo list (same as git clone)
	complete -c nw -n "test (count (commandline -opc)) -eq 1" -a "(repo_list_for_org | fzf)" -f
	complete -c cw -n "test (count (commandline -opc)) -eq 1" -a "(repo_list_for_org | fzf)" -f
end

