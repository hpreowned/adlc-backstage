# adlc-backstage

Backstage TechDocs site and catalog entities for ADLC (agent-ready repos for GitHub Copilot CLI).
Independent of the kit: the kit at `hpreowned/adlc-kit` stays the source of truth and this repo
mirrors its documents at the tag pinned in `kit.ref`.

- `docs/` + `mkdocs.yml` — TechDocs site (techdocs-core, strict build)
- `catalog-info.yaml` — System `adlc`, Component `adlc-kit`, Resource `adlc-scorecard`, template location
- `templates/adlc-onboard/` — scaffolder template: one click runs `adlc init` on a repo and opens the PR
- `.github/workflows/adlc-onboard.yml` — the workflow that template dispatches (needs `ADLC_ONBOARD_TOKEN`)
- `scripts/sync.sh` — mirrors kit/pilot pages and generates the CLI reference; CI fails on drift

Local: `make venv sync build`. Register `catalog-info.yaml`'s URL in Backstage. Replace
`group:default/platform-team` with the real owner.

Bump the kit: edit `kit.ref`, `make sync`, review the diff, PR.
