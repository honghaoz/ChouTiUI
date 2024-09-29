.DEFAULT_GOAL := help

REPO_ROOT = $(shell git rev-parse --show-toplevel)
MAKEFILE_DIR = $(shell cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

.PHONY: bootstrap
bootstrap: # Bootstrap the environment.
	@scripts/bootstrap.sh

.PHONY: build
build: # Build with debug configuration.
	@$(REPO_ROOT)/scripts/swift-package/build-workspace.sh --workspace-path "Project.xcworkspace" --scheme "ChouTiUI" --configuration "Debug" --os "macOS iOS tvOS visionOS"

.PHONY: build-release
build-release: # Build with release configuration on all platforms.
	@$(REPO_ROOT)/scripts/swift-package/build-workspace.sh --workspace-path "Project.xcworkspace" --scheme "ChouTiUI" --configuration "Release" --os "macOS iOS tvOS visionOS"

.PHONY: build-release-macOS
build-release-macOS: # Build with release configuration on macOS.
	@$(REPO_ROOT)/scripts/swift-package/build-workspace.sh --workspace-path "Project.xcworkspace" --scheme "ChouTiUI" --configuration "Release" --os "macOS"

.PHONY: build-release-iOS
build-release-iOS: # Build with release configuration on iOS.
	@$(REPO_ROOT)/scripts/swift-package/build-workspace.sh --workspace-path "Project.xcworkspace" --scheme "ChouTiUI" --configuration "Release" --os "iOS"

.PHONY: build-release-tvOS
build-release-tvOS: # Build with release configuration on tvOS.
	@$(REPO_ROOT)/scripts/swift-package/build-workspace.sh --workspace-path "Project.xcworkspace" --scheme "ChouTiUI" --configuration "Release" --os "tvOS"

.PHONY: build-release-visionOS
build-release-visionOS: # Build with release configuration on visionOS.
	@$(REPO_ROOT)/scripts/swift-package/build-workspace.sh --workspace-path "Project.xcworkspace" --scheme "ChouTiUI" --configuration "Release" --os "visionOS"

.PHONY: test
test: # Run tests on all platforms.
	@$(REPO_ROOT)/scripts/swift-package/test-workspace.sh --workspace-path "Project.xcworkspace" --scheme "ChouTiUI" --os "macOS iOS tvOS visionOS"

.PHONY: test-macOS
test-macOS: # Run tests on macOS.
	@$(REPO_ROOT)/scripts/swift-package/test-workspace.sh --workspace-path "Project.xcworkspace" --scheme "ChouTiUI" --os "macOS"

.PHONY: test-iOS
test-iOS: # Run tests on iOS.
	@$(REPO_ROOT)/scripts/swift-package/test-workspace.sh --workspace-path "Project.xcworkspace" --scheme "ChouTiUI" --os "iOS"

.PHONY: test-tvOS
test-tvOS: # Run tests on tvOS.
	@$(REPO_ROOT)/scripts/swift-package/test-workspace.sh --workspace-path "Project.xcworkspace" --scheme "ChouTiUI" --os "tvOS"

.PHONY: test-visionOS
test-visionOS: # Run tests on visionOS.
	@$(REPO_ROOT)/scripts/swift-package/test-workspace.sh --workspace-path "Project.xcworkspace" --scheme "ChouTiUI" --os "visionOS"

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
