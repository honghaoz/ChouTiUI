.DEFAULT_GOAL := help

REPO_ROOT = $(shell git rev-parse --show-toplevel)
MAKEFILE_DIR = $(shell cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

.PHONY: bootstrap
bootstrap: # Bootstrap the environment.
	@scripts/bootstrap.sh

.PHONY: build
build: # Build with debug configuration.
	@$(REPO_ROOT)/scripts/swift-package/build-workspace.sh --workspace-path "Project.xcworkspace" --scheme "ChouTiUI" --configuration "Debug" --os "iOS macOS visionOS"

.PHONY: build-release
build-release: # Build the package.
	@$(REPO_ROOT)/scripts/swift-package/build-workspace.sh --workspace-path "Project.xcworkspace" --scheme "ChouTiUI" --configuration "Release" --os "iOS macOS visionOS"

.PHONY: test
test: # Run tests.
	@$(REPO_ROOT)/scripts/swift-package/test-workspace.sh --workspace-path "Project.xcworkspace" --scheme "ChouTiUI" --os "iOS macOS visionOS"

.PHONY: test-codecov
test-codecov: # Run tests with code coverage.
	@$(REPO_ROOT)/scripts/retry.sh --max-attempts 3 --delay 3 \
	  swift test -Xswiftc -DTEST --enable-code-coverage | $(REPO_ROOT)/bin/xcbeautify
	xcrun llvm-cov export -format="lcov" .build/debug/ChouTiUIPackageTests.xctest/Contents/MacOS/ChouTiUIPackageTests -instr-profile .build/debug/codecov/default.profdata > .build/debug/codecov/coverage.lcov
	$(REPO_ROOT)/scripts/filter-lcov.sh .build/debug/codecov/coverage.lcov --keep-pattern '.+Sources/.+'

.PHONY: clean
clean: # Clean build data.
	swift package clean

.PHONY: format
format: # Format the code.
	@"$(REPO_ROOT)/scripts/format.sh" --all

.PHONY: lint
lint: # Lint the code.
	@"$(REPO_ROOT)/scripts/lint.sh" --all

.PHONY: help
help:
	@awk 'BEGIN {FS = ":.*?# "}; /^[a-zA-Z_-]+:.*?# .*$$/ && $$1 != "help" {system("tput bold; tput setaf 6"); printf "%-20s", $$1; system("tput sgr0"); print $$2}' $(MAKEFILE_LIST)
