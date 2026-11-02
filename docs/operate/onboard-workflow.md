# Onboarding workflow and token

The Backstage template dispatches `.github/workflows/adlc-onboard.yml` in
`hpreowned/adlc-backstage` with three inputs: `target_repo`, `kit_ref`, `skill_profile`. The
workflow installs the kit at the tag, clones the target, runs `adlc init --yes` and
`adlc lint`, pushes `adlc/onboard-<kit_ref>` and opens a PR whose body is the doctor output.
It can also be run by hand from the Actions tab.

## Two tokens, two places

**Backstage's GitHub integration** needs `actions: write` on `hpreowned/adlc-backstage` so the
scaffolder's `github:actions:dispatch` action can start the workflow. That is the integration
token already configured in `app-config.yaml`; add the permission, do not create a second one.
The template also requires `@backstage/plugin-scaffolder-backend-module-github` to be installed.

**The workflow's own token** is separate and is the one that touches target repos:

One repository secret, `ADLC_ONBOARD_TOKEN`, read only through `GH_TOKEN` in the job's
environment. Use a fine-grained personal access token or a GitHub App installation token
with:

| permission | level | why |
|---|---|---|
| Contents | read and write | clone, push the branch |
| Pull requests | read and write | open the PR |
| Metadata | read | implied |

Scope it to the repositories you intend to onboard, not the whole org. Rotate it like any
other deploy credential. It is never echoed; the workflow writes nothing but the branch and
the PR.

## Failure modes

| symptom | cause | fix |
|---|---|---|
| `gh repo clone` fails with 404 | token lacks access to the target | add the repo to the token's repository list |
| push rejected | branch protection forbids new branches from this token | allow the App or user, or run `adlc init` locally |
| "nothing to onboard" | repo is already on that kit tag | nothing to do |
| lint fails | the target already had an `AGENTS.md` whose backticked paths do not exist | fix the paths in the PR |
