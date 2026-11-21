#!/bin/bash

set -e

# OVERVIEW:
# Downloads scripts from https://github.com/honghaoz/ChouTi.

REPO_ROOT=$(git rev-parse --show-toplevel)

cd "$REPO_ROOT" || exit 1

# branch of ChouTi
BRANCH="master"

# an array of scripts to download
declare -a scripts=(
  "scripts/download-bin/download-bin-helpers.sh"
  "scripts/download-bin/download-bins.sh"
  "scripts/download-bin/download-swiftformat.sh"
  "scripts/download-bin/download-swiftlint.sh"
  "scripts/download-bin/download-xcbeautify.sh"
  "scripts/git/install-git-hooks.sh"
  "scripts/git/git-hooks/post-checkout"
  "scripts/git/git-hooks/post-merge"
  "scripts/git/git-hooks/pre-commit"
  "scripts/git/git-hooks/prepare-commit-msg"
  "scripts/imports/group-imports.sh"
  "scripts/imports/group-imports.swift"
  "scripts/imports/ImportGroups.swift"
  "scripts/swift-package/build-package-xcodebuild.sh"
  "scripts/swift-package/test-package.sh"
  "scripts/swift-package/test-package-xcodebuild.sh"
  "scripts/swift-package/update-packages.sh"
  "scripts/xcodebuild/build-project.sh"
  "scripts/filter-lcov.sh"
  "scripts/format.sh"
  "scripts/lint.sh"
  "scripts/retry.sh"
  "scripts/swiftformat-beautify"
  "scripts/swiftlint-beautify"
)

# --retry covers timeouts and HTTP 408/429/5xx. --retry-all-errors is required
# for a dropped connection (curl 56), and with -f it also retries 4xx.
# --connect-timeout and --max-time turn a stall into a retryable failure.
# --retry-max-time only limits when a new retry may start.
#
# keep this array in sync with the same flags in scripts/bootstrap.sh
CURL_RETRY=(
  -fsSL
  --retry 5
  --retry-all-errors
  --retry-delay 2
  --retry-max-time 90
  --connect-timeout 10
  --max-time 30
)

# Gets the file and directory listing of a path on GitHub.
function get_contents() {
  if [ -z "$1" ]; then
    echo "Error: No path provided to get_contents" >&2
    return 1
  fi
  local path="$1"

  # remove trailing slash if it exists
  path="${path%/}"

  # curl only discards a failed attempt's body when writing to a file, not when
  # stdout is captured, so a retried drop would otherwise concatenate JSON
  local tmp files_list dirs_list ok
  tmp=$(mktemp)
  trap 'rm -f "$tmp"' EXIT

  # this function only runs inside $(...), where set -e is off, so a failed
  # curl or jq must be checked explicitly or the empty listing looks successful
  ok=0
  if curl "${CURL_RETRY[@]}" \
      "https://api.github.com/repos/honghaoz/ChouTi/contents/$path?ref=$BRANCH" \
      -o "$tmp" \
    && files_list=$(jq -r '.[] | select(.type == "file") | .path' "$tmp") \
    && dirs_list=$(jq -r '.[] | select(.type == "dir") | .path' "$tmp"); then
    ok=1
  fi
  trap - EXIT
  rm -f "$tmp"
  [ "$ok" -eq 1 ] || return 1

  echo "FILESSTART"
  echo "$files_list"
  echo "FILESEND"
  echo "DIRSSTART"
  echo "$dirs_list"
  echo "DIRSEND"
}

# Downloads an executable file from GitHub.
function download_file() {
  if [ -z "$1" ]; then
    echo "Error: No path provided to download_file" >&2
    return 1
  fi
  local path="$1"
  echo "Downloading $path"
  mkdir -p "$(dirname "$path")"

  # write to a temp file so a failed or truncated response can't replace a
  # previously downloaded script
  local tmp
  tmp=$(mktemp "$path.XXXXXX")
  trap 'rm -f "$tmp"' EXIT
  if ! curl "${CURL_RETRY[@]}" \
    "https://raw.githubusercontent.com/honghaoz/ChouTi/$BRANCH/$path" \
    -o "$tmp"; then
    trap - EXIT
    rm -f "$tmp"
    return 1
  fi

  # mktemp creates 0600, so chmod +x would leave 0711, and a script can't run
  # without the read bit if another user executes it
  chmod 755 "$tmp"

  mv "$tmp" "$path"
  trap - EXIT
}

# Downloads a list of executable files from GitHub.
function download_files() {
  if [ -z "$1" ]; then
    echo "Error: No files provided to download_files" >&2
    return 1
  fi
  local files="$1"
  for file in $files; do
    download_file "$file"
  done
}

# Downloads a list of directories from GitHub.
function download_dirs() {
  if [ -z "$1" ]; then
    echo "Error: No dirs provided to download_dirs" >&2
    return 1
  fi

  local dirs="$1"
  for dir in $dirs; do
    # set -e is off inside $(...), so a failed listing must be checked here
    output=$(get_contents "$dir") || return 1
    files_list=$(echo "$output" | sed -n '/FILESSTART/,/FILESEND/p' | grep -av "FILESSTART" | grep -av "FILESEND" || true)
    dirs_list=$(echo "$output" | sed -n '/DIRSSTART/,/DIRSEND/p' | grep -av "DIRSSTART" | grep -av "DIRSEND" || true)

    # create local directory if it doesn't exist
    folder=$(basename "$dir")
    mkdir -p "$folder"

    cd "$folder"
    if [ -n "$files_list" ]; then
      download_files "$files_list"
    fi
    if [ -n "$dirs_list" ]; then
      download_dirs "$dirs_list"
    fi
    cd ..
  done
}

# download each script
for path in "${scripts[@]}"; do
  if [[ "$path" == */ ]]; then
    download_dirs "$path"
  else
    # path is a file
    download_file "$path"
  fi
done
