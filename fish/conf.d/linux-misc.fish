
if test "$OS_FAMILY" = "Linux"
	function ack
		ack-grep $argv
	end

	set -gx GNU_DATE date
end
