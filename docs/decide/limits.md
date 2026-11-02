# Known limits

Things the pilot does not tell you, so nobody over-reads it.

- **One Copilot CLI version, model `auto`.** Tool-choice behaviour is the thing being
  measured and it belongs to the vendor. The weekly regress exists because this will move.
- **Synthetic repos.** Realistic shape, but no years of accumulated weirdness. Expect the
  graph to matter more on a 10-year-old monolith and less on a tidy service.
- **n = 3 per cell.** Enough to see 2× effects, not 10 % ones. Single-run numbers are never
  reported; p50/p90 over the cell are.
- **Judge not yet human-verified.** `results/spotcheck.md` is generated and waiting.
  Correctness percentages carry that caveat until it is done.
- **Nine Tier 3 runs pending.** web-008 was quota-killed; `make tier3` reruns exactly those.
- **Adoption time.** 15 minutes was first measured with the kit on the Python path, which hid
  that no published tag was installable. It has since been re-measured from `uv tool install`
  of v0.1.7, and the kit now has a test that installs its own wheel.
- **Per-service memories.** Root memories are invisible to per-service Serena projects.
- **Not measured.** Developer satisfaction, review load, incident rate. The harness measures
  tokens, time and correctness on bounded tasks; it does not claim to measure velocity.
