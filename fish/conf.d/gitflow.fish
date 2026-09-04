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

function gch -d "Show a commit's message and diff, given a hash"
  if not count $argv
    echo "usage: gch <commit-hash>"
    return 1
  end
  git show $argv
end

function ghg 
	gh search code --owner $GITHUB_ORG
end

function _github_branch_url -d "Compute the GitHub web URL for a branch in the given repo dir"
  set -l dir $argv[1]
  set -l branch $argv[2]
  set -l remote (git -C $dir remote get-url origin 2>/dev/null)
  if test -z "$remote"
    return 1
  end
  set -l web (string replace -r '^(?:ssh://)?git@github\.com[:/]' 'https://github.com/' -- $remote)
  set web (string replace -r '\.git$' '' -- $web)
  echo "$web/tree/$branch"
end

function _note_branch_created -d "Record a newly created branch in today's Logseq journal"
  set -l dir $argv[1]
  set -l branch $argv[2]
  set -l path $argv[3]

  set -l text "Created branch [$branch]"
  set -l url (_github_branch_url $dir $branch)
  if test -n "$url"
    set text "$text($url)"
  end
  set text "$text at `$path`"

  if string match -q '*/*' -- $branch
    set -l ticket (string split '/' -- $branch)[1]
    set text "$text for #$ticket"
  end

  set -l today (date '+%Y-%m-%d')
  set -l escaped (string replace -a '"' '\\"' -- "$text")
  __logseq_api '{"method": "logseq.Editor.appendBlockInPage", "args": ["'"$today"'", "'"$escaped"'"]}' >/dev/null 2>&1
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

  _note_branch_created (pwd) $branchname (pwd)
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
set -gx TICKETS_DIR ~/t

# Shared helpers for worktree commands

function _wt_repo_name -d "Extract repo name from SSH URL"
  string replace -r '.*/' '' -- $argv[1] | string replace -r '\.git$' ''
end

function _ticket_root -d "Walk up from PWD to the nearest dir containing a .ticket file"
  set -l dir (pwd)
  while test -n "$dir"
    if test -e "$dir/.ticket"
      echo $dir
      return 0
    end
    if test "$dir" = /
      break
    end
    set dir (path dirname $dir)
  end
  return 1
end

function _ticket_root_for -d "Find the ~/t ticket root whose .ticket matches the given ticket id"
  set -l ticket $argv[1]
  test -n "$ticket"; or return 1
  test -d $TICKETS_DIR; or return 1
  for root in $TICKETS_DIR/*/
    set -l root (string trim -r -c '/' -- $root)
    if test -e "$root/.ticket"; and test (cat "$root/.ticket") = "$ticket"
      echo $root
      return 0
    end
  end
  return 1
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

  # If the branch carries a ticket prefix and a matching ~/t ticket root
  # exists, place the worktree under that root as <root>/<repo_name>. Keying
  # the dir off the repo (not the branch suffix) means one workspace per repo
  # per ticket, so cw/cr/cdpr find nw's workspace even though the branch is
  # named <ticket>/<slug> rather than after the repo. This is what lets one
  # Claude session, scoped to a ticket root, own every workspace for a ticket.
  if test (count $parts) -ge 2
    set -l root (_ticket_root_for $parts[1])
    if test -n "$root"
      echo $root/$repo_name
      return 0
    end
  end

  # Legacy flat layout under ~/w.
  set -l worktree_name
  if test (count $parts) -ge 2
    set worktree_name $parts[1]__{$repo_name}__(string join '_' -- $parts[2..])
  else
    set worktree_name {$branchname}__{$repo_name}
  end

  echo $WORKTREE_DIR/$worktree_name
end

function nw -d "Clone (or fetch) a repo and create a worktree with a new branch"
  # Inside a ticket root (~/t/<id>-<slug>/ with a .ticket file) the workspace
  # dir is named after the repo; only the branch suffix varies:
  #   nw <repo>                     -> branch <ticket>/<ticket-slug>, workspace <root>/<repo>
  #   nw <repo> <name>              -> branch <ticket>/<name>,        workspace <root>/<repo>
  #   nw <repo> <name> <dir_suffix> -> workspace <root>/<repo>__<dir_suffix>
  # A dir_suffix is required once <root>/<repo> is already taken (e.g. a
  # second PR against the same repo in this ticket): nw first falls back to
  # <root>/<repo>__<name> on its own, and only errors, asking for an
  # explicit dir_suffix, if that's taken too.
  # Outside a ticket root the classic form is required:
  #   nw <repo> <ticket>/<name>  -> flat worktree under ~/w (legacy)
  set -l root (_ticket_root)
  set -l branchname
  set -l worktree_path
  if test -n "$root"
    if test (count $argv) -lt 1
      echo "usage (in a ticket root): nw <repo> [branch_suffix] [dir_suffix]"
      return 1
    end
    set -l ticket (cat "$root/.ticket")
    set -l suffix
    if test (count $argv) -ge 2
      set suffix $argv[2]
    else
      # Default suffix is the ticket root's slug (PROJ-1234-fix-widget -> fix-widget).
      set suffix (string replace -r '^[A-Z][A-Z0-9_]+-[0-9]+-' '' -- (path basename $root))
      # Rootless slug (dir was just the id): fall back to the repo name.
      if test -z "$suffix" -o "$suffix" = "$ticket"
        set suffix (_wt_repo_name $argv[1])
      end
    end
    set branchname "$ticket/$suffix"

    set -l repo_name (_wt_repo_name $argv[1])
    if test (count $argv) -ge 3
      set worktree_path $root/{$repo_name}__$argv[3]
    else if not test -d $root/$repo_name
      set worktree_path $root/$repo_name
    else if not test -d $root/{$repo_name}__$suffix
      set worktree_path $root/{$repo_name}__$suffix
      echo "Note: $root/$repo_name already exists; using $worktree_path instead"
    else
      echo "Error: both $root/$repo_name and $root/{$repo_name}__$suffix already exist."
      echo "Pass a third argument to nw to name the worktree explicitly."
      return 1
    end
  else
    if test (count $argv) -lt 2
      echo "usage: nw <repo> <ticket_id/branch_suffix>"
      return 1
    end
    set branchname $argv[2]
  end

  set -l repo_url $argv[1]
  set -l repo_name (_wt_repo_name $repo_url)
  set -l clone_dir (_wt_ensure_clone $repo_url) || return 1
  if test -z "$worktree_path"
    set worktree_path (_wt_path $repo_name $branchname)
  end
  set -l main_branch (git -C $clone_dir rev-parse --abbrev-ref origin/HEAD)

  if not git -C $clone_dir worktree add -b $branchname $worktree_path $main_branch
    echo "Error: git worktree add failed"
    return 1
  end

  if not git -C $worktree_path push --set-upstream origin $branchname
    echo "Error: git push --set-upstream failed"
    return 1
  end

  _note_branch_created $worktree_path $branchname $worktree_path
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

