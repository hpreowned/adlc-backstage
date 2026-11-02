# Reusable workflows

Every onboarded repo gets one caller, `.github/workflows/adlc.yml`, which calls these reusable
workflows in `hpreowned/adlc-kit` at the pinned `kit-ref`. The caller is kit-owned; change
behaviour by bumping the kit, not by editing the caller.

| workflow | trigger in the caller | inputs (default) | permissions / secrets | does |
|---|---|---|---|---|
| `adlc-contract-lint` | pull_request | `kit-ref` | none | `adlc lint`; make it a required check |
| `adlc-baseline` | push to `main` | `kit-ref`, `project-repo` ('') | `contents: write` | `adlc baseline --no-viz`, commits the artifact `[skip ci]`, dispatches `adlc-member-baseline` to the project repo if set |
| `adlc-drift` | schedule `17 2 * * *` | `kit-ref`, `level` (repo) | none | `adlc stale --level <level> --all` |
| `adlc-regress` | schedule `23 3 * * 1` | `kit-ref`, `arm` (graphify), `setup` ('') | secret `COPILOT_GITHUB_TOKEN` | installs Copilot CLI 1.0.105, runs the smoke tasks, caches uv, npm and language servers |
| `adlc-scorecard-upload` | after regress on schedule | `kit-ref` | none | uploads the trend as an artifact the org aggregator collects |
| `adlc-federate` | project / org repo only | `kit-ref`, `level` (project), `org-repo` ('') | `contents: write` | builds the project or org graph from member repos |

## Runner requirements

Plain `ubuntu-latest`. No container. Regress installs its own tools and caches them by
`kit-ref`, Copilot version and the hash of `.serena/project.yml`. Repos whose tests need a JDK
or .NET pass a `setup` script through the `setup` input. C# repos need the .NET 10 runtime for
Serena's Roslyn server; `adlc doctor` turns red without it.

## Secrets

Only `adlc-regress` needs one: `COPILOT_GITHUB_TOKEN`, passed with `secrets: inherit` from the
caller. Set it as a repository or organisation secret. It is never written to disk by the kit
and is scrubbed from every transcript.
