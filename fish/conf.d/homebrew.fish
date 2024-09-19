
if type -P brew 2 &> /dev/null
    fish_add_path /opt/homebrew/bin /opt/homebrew/sbin
	set -gx GNU_DATE gdate

    set -gx HOMEBREW_PREFIX (brew --prefix)

	# TODO: source $HOMEBREW_PREFIX/etc/fish/* for completitions and config

    source $HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.fish
end
