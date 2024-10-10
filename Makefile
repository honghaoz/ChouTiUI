.DEFAULT_GOAL := help

REPO_ROOT = $(shell git rev-parse --show-toplevel)
MAKEFILE_DIR = $(shell cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

.PHONY: bootstrap
bootstrap: # Bootstrap the environment.
	@scripts/bootstrap.sh

.PHONY: build
build: # Build the package.
	@echo build: $(MAKEFILE_DIR_NAME)
	swift build -c release

.PHONY: format
format: # Format the code.
	@"$(REPO_ROOT)/scripts/format.sh" --all

.PHONY: lint
lint: # Lint the code.
	@"$(REPO_ROOT)/scripts/lint.sh" --all

.PHONY: help
help:
	@awk 'BEGIN {FS = ":.*?# "}; /^[a-zA-Z_-]+:.*?# .*$$/ && $$1 != "help" {system("tput bold; tput setaf 6"); printf "%-20s", $$1; system("tput sgr0"); print $$2}' $(MAKEFILE_LIST)
