
set os (uname)
if [ "$os" = "Linux" ]
	set -xg OS_FAMILY 'Linux'
else if test  "$os" = "Darwin"
	set -xg OS_FAMILY 'Darwin'
else
	set -xg OS_FAMILY 'Other'
end


set -gx EDITOR (which nvim || which vim || which vi)
function vi
	command $EDITOR $argv
end

set -gx CONFIG_SYNC_ROOT $HOME/.gsync

if test -d $HOME/.cache/bkt
    set -gx BKT_CACHE_DIR $HOME/.cache/bkt
end

set -gx PATH \
	$HOME/bin \
	$CONFIG_SYNC_ROOT/bin \
	$HOME/.local/bin \
	$HOME/.pyenv \
	$HOME/.krew/bin \
	/usr/local/bin \
	/usr/local/sbin \
	/bin \
	/sbin \
	/usr/bin \
	/usr/sbin \
	/snap/bin \
	$PATH

if test -d $CONFIG_SYNC_ROOT/bin.$OS_FAMILY
	set -gx PATH $CONFIG_SYNC_ROOT/bin.$OS_FAMILY $PATH
end

if test -d $CONFIG_SYNC_ROOT/bin.$OSTYPE
	set -gx PATH $CONFIG_SYNC_ROOT/bin.$OSTYPE $PATH
end

if test -d $HOME/.cargo/bin
	set -gx PATH $HOME/.cargo/bin $PATH
end
