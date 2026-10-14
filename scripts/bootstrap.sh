#!/bin/bash

set -e

# OVERVIEW:
# This script is used to bootstrap the development environment.

REPO_ROOT=$(git rev-parse --show-toplevel)

cd "$REPO_ROOT" || exit 1

echo "🚀 Bootstrap development environment..."
git submodule update --init --recursive --remote

OS=$(uname -s)
case "$OS" in
'Darwin') # macOS
  CPU=$(uname -m)
  case "$CPU" in
  'arm64') # on Apple Silicon Mac
    echo ""
    if [ -x "$REPO_ROOT/bin/jq" ]; then
      echo "📦 jq already present, skipping download"
    else
      echo "📦 Download jq..."
      curl -sL https://github.com/jqlang/jq/releases/download/jq-1.7.1/jq-macos-arm64 -o "$REPO_ROOT/bin/jq"
      chmod +x "$REPO_ROOT/bin/jq"
    fi

    # download scripts
    echo ""
    echo "📥 Download scripts..."
    "$REPO_ROOT/scripts/download-scripts.sh"

    # download bins
    echo ""
    echo "📦 Download bins..."
    "$REPO_ROOT/scripts/download-bin/download-bins.sh"

    # git hooks are only useful for local development, so skip them in CI
    if [ "${CI:-}" = "true" ]; then
      echo ""
      echo "🪝 Skipping git hooks install in CI"
    else
      echo ""
      echo "🪝 Install git hooks..."
      "$REPO_ROOT/scripts/git/install-git-hooks.sh"
    fi

    echo ""
    echo "🎉 Done."
    ;;
  'x86_64') # on Intel Mac
    echo "Does not support Intel Mac."
    ;;
  *)
    echo "Unknown CPU: $CPU"
    ;;
  esac
  ;;
'Linux') # on Ubuntu
  echo "Does not support Linux."
  ;;
*)
  echo "Unknown OS: $OS"
  ;;
esac
