!!! info "Mirrored, do not edit here"
    Source: [`results/REPORT.md`](https://github.com/hpreowned/adlc-pilot/blob/c9473565eb5f4212fb3d154415c8647eb3356801/results/REPORT.md) at `c9473565eb5f4212fb3d154415c8647eb3356801`. Change it there; `make sync` brings it back.

# ADLC pilot report — all tiers (2026-10-30)

Reproduce every number: `make kit org init doctor baseline federate tasks tier1 scorecard`
(Tier 2/3: `make tier2 tier3 scorecard`, resumable). Scorecard: `results/scorecard.md`.
Decision + rollout: `DECISION_ADR.md`. Every call made without asking: `DECISIONS.md`.

## 1. Scorecard (Tier 1: 12 tasks × 4 arms × 3 runs = 144 runs, one resolved model)
| arm | n | prompt tokens p50 / p90 | calls p50 | premium p50 | wall p50 / p90 | correctness | edit pass |
|---|---|---|---|---|---|---|---|
| baseline | 36 | 87k / 167k | 5 | 1 | 19.3s / 39.7s | 86% | 89% |
| serena | 36 | 76k / 182k | 5 | 1 | 20.1s / 44.3s | 89% | 100% |
| graphify | 36 | 204k / 319k | 7 | 1 | 31.4s / 60.4s | 85% | 100% |
| graphify-guard | 36 | 242k / 462k | 8 | 1 | 38.6s / 75.6s | 82% | 100% |

Per category (correctness; prompt tokens p50): literal — 83/83/83/89 %, 47k/45k/131k/104k ·
trace (n=15) — 83/83/73/70 %, 89k/87k/205k/408k · locate (n=3) — 100/100/100/67 % ·
edit (n=9) — 89/100/100/100 %. KB currency: p50 = p95 = 0 commits behind in every arm;
graph queries p50 = 1 in graphify arms.
Confidence: tokens/calls/turns from events.jsonl (exact); premium requests = billing per
prompt × multiplier, cross-checked with the stdout result event (#1582 concerns /usage,
unused); bytes-read is a proxy; model `auto` recorded per run (10/144 runs also used a
`copilot-search-a` helper); every cell is a median over 3 runs.

### Tier 2 (Java/C#, 3 tasks × 4 arms × 3 runs = 36 runs)
| arm | n | prompt tokens p50 | calls p50 | wall p50 | correctness |
|---|---|---|---|---|---|
| baseline | 9 | 115k | 6 | 30s | 78% |
| serena | 9 | 127k | 7 | 30s | 72% |
| graphify | 9 | 230k | 8 | 33s | 100% |
| graphify-guard | 9 | 265k | 9 | 36s | 89% |
Serena used 0/9; graph queried 1–2/9. One clear context win: svc-010 (Java JPA edit) 100 %
graphify vs 33 % baseline, n=3 per cell.

### Tier 3 (KB, cross-repo, cross-project; 15 tasks × 3 arms × 3 runs = 135 attempted, 126 valid)
Arms: baseline, graphify, graphify-federated (graphify + `project-graph.json` so `adlc query --level`
works). The `both` arm was not run: no arm beat baseline alone in Tiers 1–2. **web-008's 9 runs are
excluded**: the account's monthly Copilot premium-request quota ran out during them (`session.error`
"exceeded your monthly quota"); they cannot be re-run this month.

| arm | n | prompt tokens p50 / p90 | calls p50 | wall p50 / p90 | correctness | graph queried |
|---|---|---|---|---|---|---|
| baseline | 42 | 59k / 113k | 4 | 18.2s / 31.6s | 79% | 0/42 |
| graphify | 42 | 191k / 434k | 6 | 35.6s / 69.3s | 77% | 37/42 |
| graphify-federated | 42 | 230k / 487k | 7 | 40.8s / 76.6s | 85% | 36/42 |

| category | baseline | graphify | graphify-federated |
|---|---|---|---|
| archaeology | 90%; 56k (n=15) | 80%; 186k (n=15) | 90%; 200k (n=15) |
| cross-repo | 50%; 102k (n=9) | 56%; 373k (n=9) | 67%; 271k (n=9) |
| cross-project | 94%; 71k (n=9) | 94%; 199k (n=9) | 100%; 246k (n=9) |
| locate | 75%; 55k (n=6) | 83%; 166k (n=6) | 75%; 154k (n=6) |
| literal | 67%; 28k (n=3) | 67%; 71k (n=3) | 83%; 29k (n=3) |

**Knowledge base (kestrel-ops, 10 tasks × 3 runs per arm):** baseline 90% at 55k / graphify 87% at 169k / graphify-federated 93% at 171k. A 40-file docs repo fits in
Copilot's context, so the LLM-built docs graph (7.5 min, 35 model calls to build) did not pay for
itself; the federated arm's edge is within noise. **Federated impact question** (ops-008, "who is
affected if pricing changes /v1/quote"): the federated arm called `adlc query --level` 3–5 times per
run and scored 100 % in all 3 runs, as did baseline — the question was answerable from CODEOWNERS plus
grep on this small org. **Cross-repo** (web-006/007, svc-007): the hardest category for every arm
(50 / 56 / 67 %); web-007 (the `reference` vs `client_reference` idempotency bug) scored 17 % baseline vs
50 % federated (3 runs each) — the one place the project graph plausibly helped; n=3 per cell.

**Totals across tiers:** 315 runs attempted, 306 valid; agent premium requests (billing) 306, judge premium requests 246, model calls 2074, prompt tokens 56.3 M, agent wall-clock 2.9 h.

## 2. Per arm
- **baseline** — won tokens and wall in every category; lost one edit (web-009). Cost: zero.
- **serena** — statistically indistinguishable from baseline because the agent used Serena's
  tools in 1 of 36 runs; 100 % edit pass. Cost: uvx launch 0.8 s/run, LS pinned by Serena
  commit, GPL-3.0 licence review.
- **graphify** — skill invoked 36/36, graph queried 19/36; 2.3× tokens, 1.6× wall, −10 pts on
  trace, +11 pts on edits. Cost: 2–6 s CI build per repo, 48 KB skill per task.
- **graphify-guard** — hook fired every run; 2.8× tokens, 2× wall, worst correctness. Cost: as
  graphify plus the hook adapter. Not recommended.

## 3. Judge/human agreement
Spot-check sheet `results/spotcheck.md` (29 answers, arm hidden) is waiting for a human;
`adlc scorecard --spotcheck results/spotcheck.md` prints agreement. Edits judged by tests.

## 4. Adoption test (kestrel-notify, never seen by the kit)
Machine time 1.1 min, 0 deviations, both arms scored 2 on the golden task; human prose
step pre-supplied (≈5 min typing in reality). Kit fixes needed: 0. Final tag: v0.1.1
(feature release). Run on the dev machine — no Docker, so not in the devcontainer.

## 5. Not completed
- Tier 2 done (above). Tier 3 (KB + federated, 135 runs) still running;
  `make tier2 tier3 scorecard` resumes. The `both` arm was not run: no arm beat baseline.
- Devcontainer image never built; `act` not run (no Docker). Workflows verified by a stub runner.
- Copilot model pinning unavailable on this account (auto, recorded per run).
- Human spot-check not done (yours). Resolver false-positive hand-check on 29 edges not done.
- **Serena correction (2026-11-01):** 24 serena-arm runs on kestrel-services were measured with Serena not connected (Copilot reads `.mcp.json` from cwd only) and, once connected, Serena failed for want of the .NET 10 runtime. Both fixed in the kit; records invalidated; plain serena re-run (24 runs): Tier 1 services 51k/80 % vs baseline 63k/77 %, Serena used 1/15; Tier 2 140k/100 % vs 115k/78 %, Serena used 2/9 (both on the Java JPA edit). `serena-forced` (36 runs, Serena live, text search denied): 141k tokens p50, 41 s wall, 82 % correctness, Serena used in 33/36 runs — slower and no more correct than grep. Details in `DECISION_ADR.md` → "Serena, re-measured". Corrected Tier 1/Tier 2 serena rows are in `DECISION_ADR.md`.
- Lean-skill arm: run 2026-11-01 (36 runs, `results/2026-11-01-tier1-lean.jsonl`): 142k tokens p50 (vendor 204k, baseline 87k), 90 % correctness, graph queried 31/36. Better than the vendor skill on every axis; still 1.6× baseline. Folded into `DECISION_ADR.md` Tier 1 and the scorecard.
