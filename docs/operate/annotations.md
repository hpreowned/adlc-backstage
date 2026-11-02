# Catalog annotations

Adopted repos are ordinary Backstage components. They declare their ADLC state through
annotations so the catalog can show it and a later card can read it. Nothing in the kit
depends on these; they are for discovery.

```yaml
metadata:
  annotations:
    adlc.dev/kit-ref: v0.1.7            # tag of hpreowned/adlc-kit the repo is on
    adlc.dev/context: graphify,serena   # context layers adlc init configured
    adlc.dev/skill-profile: lean        # graphify skill profile (lean | vendor)
    adlc.dev/project-repo: hpreowned/kestrel-project   # where this repo federates to (optional)
```

The values are the same ones `adlc doctor` prints on its first line (`schema 1, kit 0.1.7,
context graphify,serena`). Keep them in sync when the kit bumps; the Renovate PR is the
natural place.

## Phase 2, not built

A component card showing kit version, graph freshness and last regress result. Rule for
whoever builds it: it reads the `adlc-scorecard-upload` artifact and the committed
`graphify-out/` stamp. It does not reimplement `adlc stale` in TypeScript. Backstage displays,
the kit decides.
