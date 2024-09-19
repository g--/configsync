
if status is-interactive
	if type -P pyenv &> /dev/null
		pyenv init - | source
	end
end
