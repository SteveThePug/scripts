#!/bin/bash
# cursor_ask: ask Claude a quick question in a popup that follows the mouse cursor
# Opened by SUPER+A (see cursor_follow.lua), which freezes the window once the title
# changes to "cursor-ask: <question>". Highlighted text is sent along with the first question.
# Ctrl+C stops an answer, Ctrl+D or Esc closes the window.

model=${CURSOR_ASK_MODEL:-haiku}
system="You are a terse reference assistant in a small terminal popup, about 70 columns by 20 lines. \
Reply with only the answer, starting with its first word, in 1-3 short sentences. \
No preamble, alternatives, caveats or summaries. No headings, tables or bold. \
For requests to write or make code you are a guide, not a code writer: reply with the library to use, \
then the key functions or methods in the order they would be called, one per line as \`name()\` \
and a few words on what it does. Write actual code only if the user explicitly asks to see it. \
If the question could mean two things, answer the likelier one and name the other in a few words. \
The user will ask a follow-up if they want more."
# highlighted text sent last time, so a stale selection is not sent again
seen="${XDG_RUNTIME_DIR:-/tmp}/cursor-ask-selection"
dir="${XDG_CACHE_HOME:-$HOME/.cache}/cursor-ask"

err=$(mktemp)
trap 'rm -f "$err"' EXIT
# Ctrl+C only interrupts the running answer or the prompt
trap 'printf "\n"' INT

# keep these throwaway sessions out of real projects
mkdir -p "$dir" && cd "$dir" || exit 1

title() {
    printf '\e]2;%s\a' "$1"
}

# style markdown with terminal escapes and wrap it at word boundaries, a line at a time
# so the answer still streams in
md() {
    awk -v width="$(tput cols)" '
        function inline(s) {
            s = gensub(/\*\*([^*]+)\*\*/, "\033[1m\\1\033[22m", "g", s)
            s = gensub(/(^|[^*])\*([^* ][^*]*)\*/, "\\1\033[3m\\2\033[23m", "g", s)
            return gensub(/\[([^]]+)\]\(([^)]+)\)/, "\033[4m\\1\033[24m (\\2)", "g", s)
        }
        # length on screen, without the escape sequences
        function len(s) {
            gsub(/\033\[[0-9;]*m/, "", s)
            return length(s)
        }
        # print s word-wrapped, starting with first and indenting the following lines with rest
        function wrap(s, first, rest,    w, n, i, line, used, fresh) {
            n = split(s, w, " ")
            line = first; used = len(first); fresh = 1
            for (i = 1; i <= n; i++) {
                if (!fresh && used + 1 + len(w[i]) > width) {
                    print line
                    line = rest; used = len(rest); fresh = 1
                }
                line = line (fresh ? "" : " ") w[i]
                used += (fresh ? 0 : 1) + len(w[i])
                fresh = 0
            }
            print line
        }
        /^[[:space:]]*```/ { code = !code; next }
        code { printf "  \033[33m%s\033[39m\n", $0; fflush(); next }
        {
            pre = post = rest = ""
            if (match($0, /^#+[[:space:]]+/)) {
                pre = "\033[1;36m"; post = "\033[0m"
            } else if (match($0, /^([[:space:]]*)[-*+][[:space:]]+/, m)) {
                pre = m[1] "• "; rest = sprintf("%*s", len(pre), "")
            } else if (match($0, /^>[[:space:]]?/)) {
                pre = rest = "\033[2m│\033[22m "
            }
            line = substr($0, RLENGTH > 0 ? RLENGTH + 1 : 1)
            # balanced backticks split the line into text and inline code, alternately
            n = split(line, p, "`")
            if (n % 2) {
                line = ""
                for (i = 1; i <= n; i++) line = line (i % 2 ? inline(p[i]) : "\033[33m" p[i] "\033[39m")
            } else {
                line = inline(line)
            }
            wrap(line post, pre, rest)
            fflush()
        }'
}

# the first character replaces the "thinking…" line; fails when nothing came back
render() {
    local c
    if IFS= read -r -n1 -d '' c; then
        printf '\r\e[K%s' "$c"
        cat
    else
        printf '\r\e[K'
        return 1
    fi
}

title cursor-ask

selection=$(wl-paste --primary --no-newline 2>/dev/null | head -c 20000)
if [[ -n $selection && $selection != "$(cat "$seen" 2>/dev/null)" ]]; then
    printf '%s' "$selection" >"$seen"
    width=$(($(tput cols) - 2))
    printf '\e[2mwith highlighted text (Enter on an empty line drops it):\n'
    while IFS= read -r line; do
        printf '│ %s\n' "${line:0:width}"
    done < <(head -n 3 <<<"$selection")
    lines=$(wc -l <<<"$selection")
    ((lines > 3)) && printf '│ … %d lines\n' "$lines"
    printf '\e[0m\n'
else
    selection=
fi

session=$(cat /proc/sys/kernel/random/uuid)
while true; do
    IFS= read -e -r -p $'\001\e[1;36m\002> \001\e[0m\002' q
    status=$?
    ((status == 1)) && exit # Ctrl+D
    ((status > 128)) && continue # Ctrl+C
    if [[ -z ${q//[[:space:]]/} ]]; then
        if [[ -n $selection ]]; then
            selection=
            printf '\e[2m(dropped the highlighted text)\e[0m\n'
        fi
        continue
    fi
    history -s "$q"
    title "cursor-ask: ${q:0:60}"

    prompt=$q
    if [[ -n $selection ]]; then
        prompt=$(printf '<selection>\n%s\n</selection>\n\n%s' "$selection" "$q")
        selection=
    fi
    # follow-ups continue the conversation once the first call has saved it
    if compgen -G "$HOME/.claude/projects/*/$session.jsonl" >/dev/null; then
        resume=(--resume "$session")
    else
        resume=(--session-id "$session")
    fi

    printf '\e[2mthinking…\e[0m'
    claude -p "$prompt" --model "$model" --system-prompt "$system" "${resume[@]}" \
        --tools "" --strict-mcp-config \
        --output-format stream-json --verbose --include-partial-messages 2>"$err" |
        jq --unbuffered -j '
            if .type == "stream_event" and .event.delta.type? == "text_delta" then .event.delta.text
            elif .type == "result" and .is_error then "\u001b[31m\(.result)\u001b[0m"
            else empty end' |
        md | render || printf '\e[31m%s\e[0m' "$(tail -n 3 "$err")"
    printf '\n'
done
