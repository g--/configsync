#!/usr/bin/env bash
# Mirrors the pi footer: model, thinking, cwd, context, cost on line 1;
# ticket + open-PR links (via ~/.gsync/bin/_ticket and _workspace_prs) on line 2.
set -euo pipefail

input=$(cat)
get() { printf '%s' "$input" | jq -r "$1"; }

model=$(get '.model.display_name // .model.id // "model"')
effort=$(get '.effort.level // empty')
thinking_on=$(get '.thinking.enabled // false')
cwd_raw=$(get '.workspace.current_dir // .cwd // "~"')
ctx_pct=$(get '.context_window.used_percentage // empty')
ctx_size=$(get '.context_window.context_window_size // empty')
cost=$(get '.cost.total_cost_usd // 0')

# Tokyo Night palette (RGB), to match the pi footer's default theme.
DARK_FG="26;27;38"
LIGHT_FG="192;202;245"
MUTED_FG="86;95;137"
BLUE="122;162;247"
PURPLE="187;154;247"
CYAN="125;207;255"
GREEN="158;206;106"
YELLOW="224;175;104"
RED="247;118;142"
ORANGE="255;158;100"
TEAL="42;195;222"
GREY="65;72;104"

cwd_name=$(basename "$cwd_raw")

ctx_text=""
ctx_bg="$GREEN"
if [ -n "$ctx_pct" ] && [ "$ctx_pct" != "null" ]; then
  if [ -n "$ctx_size" ] && [ "$ctx_size" != "null" ]; then
    ctx_k=$(awk -v s="$ctx_size" 'BEGIN { printf "%dk", s/1000 }')
  else
    ctx_k="200k"
  fi
  ctx_text="ctx $(awk -v p="$ctx_pct" 'BEGIN { printf "%.1f%%", p }')/${ctx_k}"
  # Context color shifts to warning at 70%, error at 90% — same thresholds pi uses.
  warn=$(awk -v p="$ctx_pct" 'BEGIN{print (p>=90)?2:(p>=70)?1:0}')
  case "$warn" in
    2) ctx_bg="$RED" ;;
    1) ctx_bg="$YELLOW" ;;
  esac
fi

cost_text=$(awk -v c="$cost" 'BEGIN { printf "$%.2f", c }')

SEG_BG=()
SEG_FG=()
SEG_TEXT=()

SEG_BG+=("$BLUE");   SEG_FG+=("$DARK_FG"); SEG_TEXT+=("🤖 $model")

if [ -n "$effort" ] && [ "$effort" != "null" ]; then
  SEG_BG+=("$PURPLE"); SEG_FG+=("$DARK_FG"); SEG_TEXT+=("🧠 $effort")
elif [ "$thinking_on" = "true" ]; then
  SEG_BG+=("$PURPLE"); SEG_FG+=("$DARK_FG"); SEG_TEXT+=("🧠 on")
fi

SEG_BG+=("$CYAN");   SEG_FG+=("$DARK_FG"); SEG_TEXT+=("📁 $cwd_name")

if [ -n "$ctx_text" ]; then
  SEG_BG+=("$ctx_bg"); SEG_FG+=("$DARK_FG"); SEG_TEXT+=("🪟 $ctx_text")
fi

SEG_BG+=("$GREY");   SEG_FG+=("$LIGHT_FG"); SEG_TEXT+=("💸 $cost_text")

# Rounded powerline caps (U+E0B6 leading, U+E0B4 trailing/internal), written as
# raw UTF-8 bytes via ANSI-C quoting so the source file never carries the
# literal PUA glyph. One cap per seam: the outer edges round into the terminal
# default, internal seams round from this segment's color into the next
# segment's — that overlap is what makes adjacent pills read as one continuous
# rounded chain instead of separate boxes.
RCAP=$'\xEE\x82\xB4'

# Fade-in before the first pill: shade blocks of increasing density (U+2591-93,
# standard Unicode, not PUA) colored with the first segment's own color, butted
# directly against that pill's solid fill — the density ramp itself is the
# opening transition, so no separate rounded cap is needed there.
line1="\033[38;2;${SEG_BG[0]}m░▒▓\033[0m"
count=${#SEG_BG[@]}
for i in "${!SEG_BG[@]}"; do
  bgc="${SEG_BG[$i]}"
  fgc="${SEG_FG[$i]}"
  text="${SEG_TEXT[$i]}"
  line1+="\033[48;2;${bgc}m\033[38;2;${fgc}m ${text} \033[0m"
  if [ "$i" -lt $((count - 1)) ]; then
    next_bg="${SEG_BG[$((i+1))]}"
    line1+="\033[38;2;${bgc}m\033[48;2;${next_bg}m${RCAP}"
  else
    line1+="\033[38;2;${bgc}m${RCAP}\033[0m"
  fi
done

printf "%b\n" "$line1"

# --- Line 2: ticket + open PRs for this workspace, via the shared gsync helpers. ---
ticket_bin="$HOME/.gsync/bin/_ticket"
prs_bin="$HOME/.gsync/bin/_workspace_prs"

ticket=""
if [ -x "$ticket_bin" ]; then
  ticket=$(cd "$cwd_raw" 2>/dev/null && "$ticket_bin" 2>/dev/null | head -n1 | tr -d '\000-\037\177' | cut -c1-64) || true
fi

line2=""
if [ -n "$ticket" ]; then
  ticket_label="\033[38;2;${ORANGE}m🎫\033[0m \033[38;2;${MUTED_FG}m${ticket}\033[0m"
  if [ -n "${JIRA_BASE:-}" ]; then
    ticket_url="${JIRA_BASE%/}/browse/${ticket}"
    ticket_label=$(printf '\033]8;;%s\a%b\033]8;;\a' "$ticket_url" "$ticket_label")
  else
    ticket_label=$(printf '%b' "$ticket_label")
  fi
  line2+="$ticket_label"
fi

if [ -x "$prs_bin" ]; then
  prs_json=$("$prs_bin" "$cwd_raw" 2>/dev/null || echo '[]')
  pr_count=$(printf '%s' "$prs_json" | jq 'length' 2>/dev/null || echo 0)
  if [ "$pr_count" -gt 0 ] 2>/dev/null; then
    multi_repo=$(printf '%s' "$prs_json" | jq -r '[.[].repo] | unique | length > 1')
    links=""
    while IFS=$'\t' read -r number url repo; do
      short_repo="${repo##*/}"
      if [ "$multi_repo" = "true" ]; then
        label="${short_repo}#${number}"
      else
        label="#${number}"
      fi
      colored_label=$(printf '\033[4m\033[38;2;%sm%s\033[0m' "$TEAL" "$label")
      hyperlinked=$(printf '\033]8;;%s\a%s\033]8;;\a' "$url" "$colored_label")
      links="${links:+$links }$hyperlinked"
    done < <(printf '%s' "$prs_json" | jq -r '.[] | [.number, .url, .repo] | @tsv')
    [ -n "$line2" ] && line2+="   "
    line2+="\033[38;2;${TEAL}m🔀\033[0m $links"
  fi
fi

if [ -n "$line2" ]; then
  printf "%b\n" "${line2}"
fi
