function land
    rebase
    set BASE (git merge-base (_main) HEAD)
	git log $BASE..HEAD

	while true
		read -l -P 'Ready to land? [y/r/N] ' confirm

		switch $confirm
		  case Y y
			gpush
			gh pr merge --rebase --auto
			return 0
		  case R r
		    rebase_interactive
			continue
		  case '' N n
			return 1
		end
	end
end

