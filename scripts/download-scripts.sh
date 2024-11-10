#!/bin/bash

set -e

# OVERVIEW:
# Download scripts from https://github.com/honghaoz/ChouTi

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
  "scripts/swift-package/build-workspace.sh"
  "scripts/swift-package/test-workspace.sh"
  "scripts/xcodebuild/build-project.sh"
  "scripts/filter-lcov.sh"
  "scripts/format.sh"
  "scripts/lint.sh"
  "scripts/retry.sh"
  "scripts/swiftformat-beautify"
  "scripts/swiftlint-beautify"
)

# Get the contents of a directory on GitHub
function get_contents() {
  if [ -z "$1" ]; then
    echo "Error: No path provided to get_contents" >&2
    return 1
  fi
  local path="$1"

  # remove trailing slash if it exists
  path="${path%/}"

  local contents=$(curl -s "https://api.github.com/repos/honghaoz/ChouTi/contents/$path?ref=$BRANCH")
  
  echo "FILESSTART"
  echo "$contents" | jq -r '.[] | select(.type == "file") | .path'
  echo "FILESEND"
  echo "DIRSSTART"
  echo "$contents" | jq -r '.[] | select(.type == "dir") | .path'
  echo "DIRSEND"
}

# Download an executable file from GitHub
function download_file() {
  if [ -z "$1" ]; then
    echo "Error: No path provided to download_file" >&2
    return 1
  fi
  local path="$1"
  echo "Downloading $path"
  mkdir -p "$(dirname "$path")"
  curl -fsSL https://raw.githubusercontent.com/honghaoz/ChouTi/$BRANCH/$path -o "$path"
  chmod +x "$path"
}

# Download a list of executable files from GitHub
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

# Download a list of directories from GitHub
function download_dirs() {
  if [ -z "$1" ]; then
    echo "Error: No dirs provided to download_dirs" >&2
    return 1
  fi

  local dirs="$1"
  for dir in $dirs; do
    output=$(get_contents "$dir")
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
