---
allowed-tools: Bash(_ticket)
---

Append the following note to today's Logseq journal page using the `logseq-rw` MCP server's `update_page` tool with `mode: "append"`. Do not use Logseq's native MCP endpoint, read an API token, or construct an authenticated HTTP request.

Today's date for the journal page is: {{currentDate}}

The current ticket id is: !`_ticket`

If the ticket id above is non-empty, prepend `#<TICKET> ` to the note (e.g. `#PROJ-1234 working on something`). If it is empty, append the note unchanged.

The note to append:
$ARGUMENTS
