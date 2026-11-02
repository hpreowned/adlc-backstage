# adlc-backstage

Backstage TechDocs site and catalog entities for ADLC (agent-ready repos for GitHub Copilot CLI).
Independent of the kit: the kit at `hpreowned/adlc-kit` stays the source of truth and this repo
mirrors its documents at the tag pinned in `kit.ref`.

- `docs/` + `mkdocs.yml` — TechDocs site (techdocs-core, strict build)
- `catalog-info.yaml` — System `adlc`, Component `adlc-kit`, Resource `adlc-scorecard`, template location
- `templates/adlc-onboard/` — scaffolder template: one click runs `adlc init` on a repo and opens the PR
- `.github/workflows/adlc-onboard.yml` — the workflow that template dispatches (needs `ADLC_ONBOARD_TOKEN`)
- `scripts/sync.sh` — mirrors kit/pilot pages and generates the CLI reference; CI fails on drift

Local: `make venv sync build` (set `VENV=/somewhere/outside` when a local Backstage reads this checkout as a `file:` location; a venv inside the tree breaks TechDocs). Register `catalog-info.yaml`'s URL in Backstage. Replace
`group:default/platform-team` with the real owner.

Diagrams are Mermaid fences (GitHub renders them natively). In Backstage install
`backstage-plugin-techdocs-addon-mermaid` in `packages/app` (new frontend system discovers it
via its `/alpha` module); `mkdocs.yml` already emits the `<div class="mermaid">` the addon expects.

Register with a `url:` location. A `file:` location makes the local TechDocs builder patch
`mkdocs.yml` inside the source tree; for a local demo point it at an rsync copy.

Bump the kit: edit `kit.ref`, `make sync`, review the diff, PR.
