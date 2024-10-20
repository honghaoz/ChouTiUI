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

.PHONY: build-playground-macOS
build-playground-macOS: # Build the macOS playground.
	@./scripts/xcodebuild/build-project.sh --project "./playgrounds/ChouTiUIPlayground-macOS/ChouTiUIPlayground-macOS.xcodeproj" --scheme "ChouTiUIPlayground-macOS" --configuration "Release" --os "macOS"

.PHONY: build-playground-iOS
build-playground-iOS: # Build the iOS playground.
	@./scripts/xcodebuild/build-project.sh --project "./playgrounds/ChouTiUIPlayground-iOS/ChouTiUIPlayground-iOS.xcodeproj" --scheme "ChouTiUIPlayground-iOS" --configuration "Release" --os "iOS"

.PHONY: format
format: # Format the code.
	@"$(REPO_ROOT)/scripts/format.sh" --all

.PHONY: lint
lint: # Lint the code.
	@"$(REPO_ROOT)/scripts/lint.sh" --all

.PHONY: help
help:
	@awk 'BEGIN {FS = ":.*?# "}; /^[a-zA-Z_-]+:.*?# .*$$/ && $$1 != "help" {system("tput bold; tput setaf 6"); printf "%-24s", $$1; system("tput sgr0"); print $$2}' $(MAKEFILE_LIST)
