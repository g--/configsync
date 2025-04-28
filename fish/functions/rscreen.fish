function rscreen
    if count $argv > /dev/null
        ssh -t $argv screen -d -RR -e ^Tt -h 10000
    else
		echo "Usage: "
		echo "    rscreen <host>"
		echo "    rscreen <host> sudo"
		echo ""
    end
end
