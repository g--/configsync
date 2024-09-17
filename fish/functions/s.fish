
function s 
	# TODO adjust origin/main

	set BRANCH (git branch --show-current)
	if [ "$BRANCH" != "" ]
		echo $BRANCH
	else
		echo "Not on a branch"
	end

	# commit stack here
	set COMMITS (git log --format=reference origin/main..HEAD)

	if [ "$COMMITS" != "" ]
		echo $COMMITS

		# changed files in commits
		git diff --stat origin/main HEAD
		echo ""
	end

	set UNCOMMITED ( git status -s )
	if [ "$UNCOMMITTED" != "" ]
		echo $UNCOMMITTED
		echo ""
	end

	# is there an open PR?, 
	gh pr view --json state,reviewDecision,url,number 2>/dev/null | jq -r '.state, .reviewDecision, .url, .number' | read -L -l STATE DECISION URL NUMBER
	if [ "$NUMBER" != "" ]
	    echo "pr $NUMBER is in $STATE / $DECISION -- see $URL"
		# STATE is either OPEN or MERGED
		# DECISION is either "", "APPROVED", "REVIEW_REQUIRED", or "??"
	end
end


