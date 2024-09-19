
function s 
	# TODO adjust origin/main
	# TODO parallel execution for snappier response?

	set ticket (_ticket)
	if [ "$ticket" != "" ]; and [ "$JIRA_BASE" != "" ]
		set_color --bold black
		echo "Ticket"
		set_color normal

		echo -n "   "
		jira view --template=title $ticket
		echo ""
	end

	set BRANCH (git branch --show-current)
	if [ "$BRANCH" != "" ]
		set_color --bold black
		echo "Branch"
		set_color normal
		echo "   " $BRANCH
		echo ""
	else
		echo "(no branch)"
	end

	# commit stack here
	set COMMITS (git log --format=reference --color=always origin/main..HEAD)

	if [ "$COMMITS" != "" ]
		set_color --bold black;
		echo "Commits"
		set_color normal
		printf %s\n $COMMITS

		# changed files in commits
		git diff --stat origin/main HEAD
		echo ""
	end

	set UNCOMMITTED ( git status -s )
	if [ "$UNCOMMITTED" != "" ]
		set_color --bold black;
		echo "Uncommitted"
		set_color normal
		printf %s\n $UNCOMMITTED
		echo ""
	end

	# is there an open PR?, 
	gh pr view --json state,reviewDecision,url,number 2>/dev/null | jq -r '.state, .reviewDecision, .url, .number' | read -L -l STATE DECISION URL NUMBER
	if [ "$NUMBER" != "" ]
		set_color --bold black;
		echo "Pull Request"
		set_color normal
		echo '    ' (_url "$URL" "pr $NUMBER is in $STATE / $DECISION")
		#printf '    %s\e]8;;%s\e\\\\%s\e]8;;\e\\\\\n' "$URL" "pr $NUMBER is in $STATE / $DECISION"
	end
end


