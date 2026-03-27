function dw
	if test (count $argv) -eq 0
		echo "Usage: dw <worktree-path>"
		return 1
	end

	set wt_path (realpath $argv[1] 2>/dev/null; or echo $argv[1])

	# Verify it's actually a worktree
	set match (git worktree list --porcelain | string match -r "worktree $wt_path\$")
	if test -z "$match"
		echo "Error: '$argv[1]' is not a git worktree"
		return 1
	end

	# Get branch and upstream info from within the worktree
	set branch (git -C $wt_path rev-parse --abbrev-ref HEAD 2>/dev/null)
	if test $status -ne 0
		echo "Error: could not determine branch for '$argv[1]'"
		return 1
	end

	set upstream (git -C $wt_path rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null)
	if test -z "$upstream"
		echo "Error: branch '$branch' has no upstream tracking branch"
		return 1
	end

	set local_sha (git -C $wt_path rev-parse HEAD)
	set remote_sha (git -C $wt_path rev-parse $upstream 2>/dev/null)
	if test "$local_sha" != "$remote_sha"
		echo "Error: branch '$branch' is not in sync with '$upstream'"
		return 1
	end

	git worktree remove $wt_path
	and echo "Removed worktree '$argv[1]' (branch: $branch)"
end
