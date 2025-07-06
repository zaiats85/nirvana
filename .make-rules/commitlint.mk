GITHUB_BASE_REF ?= main
COMMITLINT_CONFIG ?= commitlint.config.js

.PHONY: commit-lint
commit-lint:
	commitlint -g $(COMMITLINT_CONFIG) --from=$$(git rev-parse remotes/origin/$(GITHUB_BASE_REF))
