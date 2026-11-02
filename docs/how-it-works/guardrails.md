# Guardrails

What the kit refuses to do, enforced in code or CI, not in prose.

| guardrail | mechanism |
|---|---|
| no secrets in repos | `COPILOT_GITHUB_TOKEN` comes from the environment (`gh auth token`); transcripts are scrubbed before they are written; tests assert it |
| no LLM in headless builds | `GRAPHIFY_BACKEND=none` for every CI and headless run; the semantic pass exists only inside an interactive Copilot session |
| no telemetry, no hosted services | no Graphify Cloud, no hosted MCP; `adlc lint` fails on a hosted or unknown MCP server in `.mcp.json` |
| Serena is read-mostly | the context file allows exactly ten tools: find_symbol, find_referencing_symbols, get_symbols_overview, find_implementations, get_diagnostics_for_file, replace_symbol_body, insert_after_symbol, insert_before_symbol, read_memory, list_memories; lint fails on anything else |
| memories are not agent-writable | no write tool in the allowlist; `adlc baseline` regenerates them from `AGENTS.md` and the graph report |
| kit-owned text stays kit-owned | the routing section and the fenced `adlc:` block in `AGENTS.md` are rewritten by `adlc init`; lint fails if a human edits them |
| pinned everything | Copilot CLI, graphify wheel sha, Serena commit, Python, kit tag; `PINS.md` is generated and `adlc pins --check` runs in kit CI |
| hook guard off by default | a pre-tool-use hook that denies text search exists for experiments (`adlc force-hook`); the pilot measured it and it is not shipped on by default |
| nothing outside the repo | `adlc init` writes nothing under `~`; nothing in `~/.copilot` is required |
