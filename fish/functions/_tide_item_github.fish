function _tide_item_github
	if gh pr view --json state,reviewDecision 2>/dev/null | jq -r '.state, .reviewDecision' | read -L -l STATE DECISION
		if [ "$DECISION" != "REVIEW_REQUIRED" ]
			set show $DECISION
		else
			set show $STATE
		end

		echo "trying to show $show" >> /tmp/test_log.log
		#set location $_tide_location_color$location

        _tide_print_item github ' ' (
        echo -ns ' '$show)
	else
		echo "nope" >> /tmp/test_log.log
	end
end
