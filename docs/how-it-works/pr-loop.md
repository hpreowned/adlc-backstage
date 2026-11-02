# The PR loop

Nothing about day-to-day work changes except one required check and one file engineers own.

| when | what runs | who writes what |
|---|---|---|
| on a branch | Copilot CLI reads `AGENTS.md` and the routing section on its own | engineer and agent write code; the agent may run `adlc baseline --incremental` locally and must not commit it |
| PR opened | `adlc-contract-lint` (required check) | fails on an edited kit-owned block, a backticked path that does not exist, a broken Serena pin or tool allowlist |
| merged to `main` | `adlc-baseline` | rebuilds the graph with no LLM, stamps it with the commit, commits `graphify-out/` and `.serena/memories/` back with `[skip ci]`, pings the project repo to re-federate |
| nightly 02:17 | `adlc-drift` | `adlc stale --all`; a repo more than 10 commits behind its stamp is reported |
| weekly Mon 03:23 | `adlc-regress` then `adlc-scorecard-upload` | reruns the smoke tasks on one arm, uploads the scorecard artifact |
| kit bump | Renovate | opens the PR that moves `kit-ref`; `adlc upgrade` handles schema changes |

Three consequences worth stating out loud.

**One writer for derived artifacts.** CI on `main` is the only thing that commits the graph or
the memories. Engineers never rebuild and commit them, so two people merging on the same day
do not conflict on a 5 MB JSON file.

**Knowledge changes ride the code PR.** A new convention or a moved module is an edit to
`AGENTS.md` in the same PR. Lint checks the paths; review checks the words. There is no
separate wiki to forget.

**Between merge and baseline the graph is briefly behind.** The agent is told to run
`adlc stale` before trusting it. See [Freshness](freshness.md).
