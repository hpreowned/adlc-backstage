SHELL := /bin/bash
# Keep the builder venv OUTSIDE the repo when Backstage reads this tree as a file: location —
# TechDocs refuses source trees containing symlinks that point outside them.
VENV ?= .venv
.PHONY: venv sync check build serve
venv:            ## local builder identical to CI and Backstage
	uv venv -q --clear -p 3.12 $(VENV) && uv pip install -q -p $(VENV)/bin/python -r requirements.txt
sync:            ## mirror kit/pilot pages at kit.ref + regenerate CLI reference
	scripts/sync.sh
check:           ## CI: mirrored pages match their pinned source
	scripts/sync.sh --check
build: venv      ## strict: any broken link or nav entry fails
	$(VENV)/bin/mkdocs build --strict
serve: venv
	$(VENV)/bin/mkdocs serve
