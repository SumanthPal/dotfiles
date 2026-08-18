# Global agent rules

Canonical shared rules for every AI coding harness on this machine. Each harness reaches this file through its own anchor (symlink or include), so edit here and every agent picks it up.

Harnesses in use: `pi`, `claude`, `codex`, `agy` (Antigravity), `muse`, `cursor-agent`, `opencode` — all coordinated in `herdr`.

## Response style

Respond terse like smart caveman. All technical substance stay. Only fluff die.

- Drop: articles (a/an/the), filler (just/really/basically), pleasantries, hedging
- Fragments OK. Short synonyms. Technical terms exact. Code unchanged.
- Pattern: `[thing] [action] [reason]. [next step].`
- Not: "Sure! I'd be happy to help you with that."
- Yes: "Bug in auth middleware. Fix:"

Switch level: `/caveman lite|full|ultra|wenyan-lite|wenyan-full|wenyan-ultra`. Stop: "stop caveman" or "normal mode".

Auto-Clarity: drop caveman for security warnings, irreversible actions, or when the user is confused. Resume after.

Boundaries: code, commits, PR text, and docs are written in normal prose.

## rtk — token-optimized shell proxy

`rtk` filters and summarizes command output before it reaches the model context. Prefix shell commands with it.

```bash
rtk git status
rtk cargo test
rtk ls src/
rtk grep "pattern" src/
rtk read path/to/file
```

Meta commands (never prefix these):

```bash
rtk gain              # token savings analytics
rtk gain --history    # command usage history with savings
rtk discover          # find missed optimization opportunities
rtk proxy <cmd>       # run raw command unfiltered (debugging)
```

Coverage differs per harness:

| Harness | How rtk applies |
|---|---|
| claude | PreToolUse Bash hook — automatic |
| pi | `rtk.ts` extension — automatic |
| cursor | preToolUse hook — automatic |
| opencode | `plugins/rtk.ts` — automatic |
| agy | **project-scoped only** (`rtk init --agent antigravity` inside a repo). No global hook, so prefix manually until a repo has it installed |
| codex, muse | **no hook processor exists** — prefix commands with `rtk` manually |

Name collision warning: if `rtk gain` fails, the wrong `rtk` is on PATH (reachingforthejack/rtk is a different tool).

## Routing — which harness for which task

Tiered rig. Cheap worker by default, escalate only the subtasks that need it.

| Task class | Send to | Why |
|---|---|---|
| Bulk codegen, single functions, boilerplate, tests, structured JSON/SQL | `pi` / `deepseek-v4-flash` | $0.14/$0.28 per M tokens, 1M context. Already the pi default. |
| Flash attempt failed or came back subtly wrong | `pi` / `deepseek-v4-pro` | $0.435/$0.87 per M — 3× Flash, still far cheaper than frontier. |
| Multi-file architecture, cross-service debugging, long tool chains | `claude` (Opus 5) | $5/$25 per M. Reserve for the ~10% that needs deep repo reasoning. |
| Tightly scoped repo change with tests, sandboxed, worktree-parallel | `codex` | Terminal-native executor. Keep the prompt outcome-focused, one task per run. |
| Plan a feature up front; audit a diff before merge | `muse` (`/plan`, `/grill`, `/goal`) | Planner and auditor at the edges of the workflow, not the middle. |
| Goal-level decomposition across tools | `agy` | Dispatcher. Give objectives with constraints, not low-level edits. |

**If you are working outside your lane, say so and hand back rather than grinding.** A cheap model burning twenty turns on an architectural refactor costs more than one Opus pass. A frontier model writing boilerplate wastes budget the other direction.

Prompting notes per harness:

- **deepseek (pi)** — give explicit signatures or schemas. Cap thinking at `high`; `max` only when genuinely needed.
- **claude** — example-heavy prompts, invite step-by-step reasoning. Repo `CLAUDE.md` is reread after compaction.
- **codex** — one well-scoped task per run. Start in suggest mode on unfamiliar repos.
- **muse** — think in goals and plans; let `/plan` → `/grill` → `/goal` do the decomposition.
- **agy** — high-level objectives with constraints (risk tolerance, models allowed).

## Skills

Canonical skills live in `~/.agents/skills`. Every harness's skills directory symlinks into it — edit the canonical copy, never a harness-local one, or the copies drift.

Two deliberate exceptions:

- `~/.codex/skills/.system` is codex-managed (imagegen, openai-docs, plugin-creator, review-agent, skill-creator, skill-installer). Leave it alone.
- `~/.pi/agent/skills/memex-search` is a real directory, not a symlink. It is a pi-specific rewrite ("Memex for Pi"), not a stale copy of the shared one — different sections, not drift. Update it by hand when the memex CLI changes.

Claude also receives the caveman skills through the `caveman@caveman` plugin marketplace, so they are not symlinked into `~/.claude/skills` a second time.
