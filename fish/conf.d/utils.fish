
function ts2date
	command $GNU_DATE -d \@$argv[1]
end

function unixtime
	command $GNU_DATE '+%s'
end


# Logseq API quick capture
# Store token in ~/.config/logseq-api-token (not in dotfiles repo)
set -g LOGSEQ_API "http://127.0.0.1:12315/api"

function __logseq_token
    if not test -f ~/.config/logseq-api-token
        echo "Missing ~/.config/logseq-api-token" >&2
        return 1
    end
    cat ~/.config/logseq-api-token
end

function __logseq_api -d "Call a Logseq API method"
    set -l token (__logseq_token) || return 1
    curl -s --max-time 5 -X POST $LOGSEQ_API \
        -H "Authorization: Bearer $token" \
        -H 'Content-Type: application/json' \
        -d "$argv[1]"
end

function t -d "Add a thought to today's Logseq journal"
    if test (count $argv) -eq 0
        echo "Usage: thought <your thought here>"
        return 1
    end
    set -l today (date '+%Y-%m-%d')
    set -l text (string join " " $argv)
    set -l escaped (string replace -a '"' '\\"' -- "$text")
    set -l result (__logseq_api '{"method": "logseq.Editor.appendBlockInPage", "args": ["'"$today"'", "'"$escaped"'"]}') || return 1
    if string match -q 'null' -- "$result"
        echo "Failed — is Logseq running?" >&2
        return 1
    end
    echo "Added to $today: $text"
end

function today -d "Show TODOs from today's Logseq journal"
    if not command -q jq
        echo "jq is required but not installed" >&2
        return 1
    end
    set -l day (date '+%Y-%m-%d')
    set -l json (__logseq_api '{"method": "logseq.Editor.getPageBlocksTree", "args": ["'$day'"]}') || return 1
    if test -z "$json"; or string match -q 'null' -- "$json"
        echo "No journal page for $day — is Logseq running?" >&2
        return 1
    end
    set -l items (echo "$json" | jq -r '.. | objects | select(.content?) | .content | select(test("^(TODO|DOING) ")) | split("\n")[0]')
    if test -z "$items"
        echo "No TODOs for $day"
        return 0
    end
    for line in $items
        if string match -q 'DOING *' -- "$line"
            set -l text (string replace 'DOING ' '' -- "$line")
            printf '\e[1;33m▶ %s\e[0m\n' "$text"
        else if string match -q 'TODO *' -- "$line"
            set -l text (string replace 'TODO ' '' -- "$line")
            printf '  □ %s\n' "$text"
        end
    end
end

# set -Ux LESS -R
