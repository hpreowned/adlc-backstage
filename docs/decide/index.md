# Verdict

Three decisions, from 378 valid runs over 29 tasks and 7 arms on four synthetic but realistic
repos (Java, Python, C#, TypeScript, ops). The full argument is the [ADR](adr.md); the
numbers are in the [pilot report](report.md).

## 1. Adopt the contract and the kit

`AGENTS.md` with the kit-owned block, routing, freshness, lint in CI, federation. Vendor-neutral,
zero per-task token cost, onboarding measured at 15 minutes from a clean `uv tool install`.
This is the durable asset, and it is also what exposed every defect below.

## 2. Graphify: opt-in, lean profile only, not the org default

Tier 1, 36 runs per arm:

| arm | prompt tokens p50 | wall p50 | correctness | edit pass |
|---|---|---|---|---|
| baseline | 87k | 19.3 s | 86 % | 89 % |
| graphify, vendor skill | 204k | 31.4 s | 85 % | 100 % |
| graphify, lean skill | 142k | 33.4 s | 90 % | 100 % |
| graphify, hook guard | 242k | 38.6 s | 82 % | 100 % |

The vendor skill costs 2.3× tokens for nothing. Lean beats vendor on every axis and is the
kit default when a team opts in, but still costs 1.6× baseline for +4 points. Where it pays:
typed-code edits (the Java JPA task goes from 33 % to 100 %). Keep the graph build in CI
because federation and cross-repo questions depend on it.

## 3. Serena: not a default; keep per service for Java and C# edits

Offered, the agent ignores it: 2 of 36 Tier 1 runs, 2 of 9 Tier 2 runs. Forced, it is 1.6×
tokens, 2.1× wall-clock and 4 points worse than baseline. Its only win is the same Java JPA
edit Graphify wins.

## What to carry into any rollout conversation

The first Serena verdict rested on 24 runs where Serena was never loaded. The eval harness was
honest; the environment underneath it was not, and only a forcing arm exposed it. Measurement
infrastructure outlives any individual tool; keep the harness, swap the tools.
