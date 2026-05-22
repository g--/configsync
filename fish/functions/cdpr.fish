function cdpr -d "cd into a worktree for a GitHub PR, creating one if needed"
  if test (count $argv) -eq 0
    echo "usage: cdpr <pr-url>"
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
  set -l repo_name (_wt_repo_name $repo_url)
  set -l worktree_path (_wt_path $repo_name $branch)

  if test -d $worktree_path
    echo "Reusing existing worktree at $worktree_path"
    cd $worktree_path
  else
    cw $repo_url $branch
  end
end
