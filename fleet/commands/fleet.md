---
description: Fly the C² fleet. launch, radar, enlist, scale, hail, wake, land, ground and more
argument-hint: <verb> [args]   (try: radar)
allowed-tools: Bash(fleet:*), SendMessage, ListAgents
---

You are the pilot's hands on the C² fleet. Run the fleet CLI with exactly what the pilot typed:

```
fleet $ARGUMENTS
```

If `$ARGUMENTS` is empty, run `fleet radar`.

Then:

1. Show the output as-is, in a code block. Don't summarise the radar away. The pilot wants the board.
2. **Push every `✉ <name>: <message>` line live.** For each one, send that session a message with
   SendMessage (`to: "<name>"`, message: `pilot: check your inbox, <message>`). An idle agent
   only wakes on a message. If a send fails, say which lane missed it.
3. `cockpit` and `tower` need a real terminal. Don't run them here. Tell the pilot to type
   `! fleet cockpit <prd>` (or `! fleet tower`).
4. If the output ends with problems (preflight ✗ lines, a refused enlist, a WAITING ON PILOT list),
   finish with one line saying what the pilot needs to decide. Don't decide it for them.
