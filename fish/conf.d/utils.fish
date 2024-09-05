
function ts2date
	command $GNU_DATE -d \@$argv[1]
end

function unixtime
	command $GNU_DATE '+%s'
end


