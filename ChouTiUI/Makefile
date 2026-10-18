.DEFAULT_GOAL := help

REPO_ROOT = $(shell git rev-parse --show-toplevel)
MAKEFILE_DIR = $(shell cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

.PHONY: build
build: # Build with debug configuration.
	@$(REPO_ROOT)/scripts/swift-package/build-package-xcodebuild.sh --package "$(MAKEFILE_DIR)" --configuration "Debug" --os "macOS iOS tvOS visionOS"

.PHONY: build-release
build-release: # Build with release configuration on all platforms.
	@$(REPO_ROOT)/scripts/swift-package/build-package-xcodebuild.sh --package "$(MAKEFILE_DIR)" --configuration "Release" --os "macOS iOS tvOS visionOS"

.PHONY: build-release-macOS
build-release-macOS: # Build with release configuration on macOS.
	@$(REPO_ROOT)/scripts/swift-package/build-package-xcodebuild.sh --package "$(MAKEFILE_DIR)" --configuration "Release" --os "macOS"

.PHONY: build-release-iOS
build-release-iOS: # Build with release configuration on iOS.
	@$(REPO_ROOT)/scripts/swift-package/build-package-xcodebuild.sh --package "$(MAKEFILE_DIR)" --configuration "Release" --os "iOS"

.PHONY: build-release-tvOS
build-release-tvOS: # Build with release configuration on tvOS.
	@$(REPO_ROOT)/scripts/swift-package/build-package-xcodebuild.sh --package "$(MAKEFILE_DIR)" --configuration "Release" --os "tvOS"

.PHONY: build-release-visionOS
build-release-visionOS: # Build with release configuration on visionOS.
	@$(REPO_ROOT)/scripts/swift-package/build-package-xcodebuild.sh --package "$(MAKEFILE_DIR)" --configuration "Release" --os "visionOS"

.PHONY: test
test: # Run tests on all platforms.
	@$(REPO_ROOT)/scripts/swift-package/test-package-xcodebuild.sh --package "$(MAKEFILE_DIR)" --os "macOS iOS tvOS visionOS"

.PHONY: test-macOS
test-macOS: # Run tests on macOS.
	@$(REPO_ROOT)/scripts/swift-package/test-package-xcodebuild.sh --package "$(MAKEFILE_DIR)" --os "macOS"

.PHONY: test-iOS
test-iOS: # Run tests on iOS.
	@$(REPO_ROOT)/scripts/swift-package/test-package-xcodebuild.sh --package "$(MAKEFILE_DIR)" --os "iOS" --beautify false

.PHONY: test-tvOS
test-tvOS: # Run tests on tvOS.
	@$(REPO_ROOT)/scripts/swift-package/test-package-xcodebuild.sh --package "$(MAKEFILE_DIR)" --os "tvOS" --beautify false

.PHONY: test-visionOS
test-visionOS: # Run tests on visionOS.
	@$(REPO_ROOT)/scripts/swift-package/test-package-xcodebuild.sh --package "$(MAKEFILE_DIR)" --os "visionOS" --beautify false

.PHONY: test-ci
test-ci: # Run tests with CI-optimized caching path. Usage: make test-ci OS=iOS [PHASE=pick|boot|build|test].
	@$(REPO_ROOT)/scripts/swift-package/test-package-xcodebuild.sh --package "$(MAKEFILE_DIR)" --os "$(OS)" --beautify false --derived-data-path "$(CURDIR)/.derived-data" $(if $(PHASE),--phase $(PHASE),)

.PHONY: test-codecov
test-codecov: # Run tests with code coverage.
	@$(REPO_ROOT)/scripts/swift-package/test-package.sh --package "$(MAKEFILE_DIR)" --max-attempts 3 --delay 3 --summary "$${GITHUB_STEP_SUMMARY:-}" --coverage-lcov .build/debug/codecov/coverage.lcov -Xswiftc -DTEST
	$(REPO_ROOT)/scripts/filter-lcov.sh .build/debug/codecov/coverage.lcov --keep-pattern '.+/ChouTiUI/Sources/.+'

.PHONY: clean
clean: # Clean build data.
	swift package clean

.PHONY: help
help:
	@awk 'BEGIN {FS = ":.*?# "}; /^[a-zA-Z_-]+:.*?# .*$$/ && $$1 != "help" {system("tput bold; tput setaf 6"); printf "%-24s", $$1; system("tput sgr0"); print $$2}' $(MAKEFILE_LIST)
