# Pins and upgrades

## What is pinned

| thing | pin | where |
|---|---|---|
| kit | git tag, currently in [kit.ref](https://github.com/hpreowned/adlc-backstage/blob/main/kit.ref) and every caller's `kit-ref` | `adlc/pins.json` → rendered into `.github/workflows/adlc.yml` and `renovate.json` by `adlc init` |
| GitHub Copilot CLI | 1.0.105 | `adlc/pins.json`; doctor compares |
| graphify | `graphifyy[leiden]==0.9.97` with wheel sha256 | `uv.lock` + `pins.json` |
| Serena | commit `ede329aa…` | `.mcp.json` (`uvx --from git+…@commit`); lint compares |
| language servers | fixed transitively by the Serena commit | pre-warm with `serena download-ls-dependencies` |
| Python | 3.12 | `pins.json`, `requires-python` |

`PINS.md` in the kit is generated from these and `adlc pins --check` fails kit CI if it is
stale. The full table is mirrored at [Reference → Pins](../reference/pins.md).

## Bumping

Renovate, using the kit's preset (`monitor/renovate-preset.json`), opens one grouped PR per
bump, Mondays before 06:00, never auto-merged. Three kinds:

1. **Kit tag.** Renovate moves `kit-ref` in the caller workflow and `renovate.json`. Then run
   `adlc init` (idempotent) on the repo so the kit stamp in `AGENTS.md` and any new files
   land; expect a three-file diff for a docs-only kit release. `adlc upgrade` handles schema
   bumps when the kit announces one.
2. **graphify / Serena.** Lint and doctor compare against `pins.json`, so a dependency bump
   without a kit bump fails on purpose. Bump the kit first.
3. **Copilot CLI.** Doctor warns on a version mismatch. The weekly regress is the canary:
   a Copilot release that changes tool-choice behaviour shows up as a scorecard shift
   before anyone notices in daily work.

## History that matters

- Tags v0.1.0 through v0.1.6 could not be installed from GitHub (`uv tool install` crashed on
  import). They only ever worked from the kit's own checkout. Use v0.1.7 or later. The
  pilot's adoption numbers were re-verified from a clean install at v0.1.7.
- 0.1.5 made per-service Serena projects the default after discovering that Copilot CLI loads
  `.mcp.json` from the working directory only, and that one failing language server disables
  the whole Serena project.
