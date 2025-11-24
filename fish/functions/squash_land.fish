function squash_land
	gh pr view -c
	read -l -P 'Comments resolved or addressed? [y/N] ' confirm
	switch $confirm
	  case Y y
	  case '' N n
		return 1
	end

    rebase
    set BASE (git merge-base (_main) HEAD)
	set commit_message (mktemp)
	git log (git merge-base (_main) HEAD)..HEAD --reverse --pretty=format:"%s%n%n%b" > $commit_message
	$EDITOR $commit_message

	read -l -P 'Ready to land? [y/N] ' confirm
	switch $confirm
	  case Y y
		git push --force
		tail -n +3 $commit_message | gh pr merge --squash --auto --subject (head -1 $commit_message) --body-file -
		return 0
	  case '' N n
		return 1
	end

	main
	echo "local files to clean up: "
	echo ""
	git ls-files --others --exclude-standard
end

