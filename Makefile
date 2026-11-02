SHELL := /bin/bash
.PHONY: venv sync check build serve
venv:            ## local builder identical to CI and Backstage
	uv venv -q --clear -p 3.12 .venv && uv pip install -q -p .venv/bin/python -r requirements.txt
sync:            ## mirror kit/pilot pages at kit.ref + regenerate CLI reference
	scripts/sync.sh
check:           ## CI: mirrored pages match their pinned source
	scripts/sync.sh --check
build: venv      ## strict: any broken link or nav entry fails
	.venv/bin/mkdocs build --strict
serve: venv
	.venv/bin/mkdocs serve
