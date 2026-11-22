#!/bin/bash

set -e

# OVERVIEW:
# Bootstraps the development environment.

# resolve the repo from this script's location so bootstrap works from any
# directory.
#
# CDPATH= and >/dev/null keep an exported CDPATH from printing the
# directory into REPO_ROOT. unset GIT_DIR so a linked worktree hook cannot
# make --show-toplevel return the current directory
if [ -z "${BASH_SOURCE[0]:-}" ]; then
  echo "Error: bootstrap must be run as a file, not piped to bash." >&2
  exit 1
fi
REPO_ROOT=$(CDPATH= cd -- "$(dirname "${BASH_SOURCE[0]}")/.." >/dev/null && unset GIT_DIR && git rev-parse --show-toplevel) || exit 1
if [ ! -f "$REPO_ROOT/scripts/bootstrap.sh" ]; then
  echo "Error: resolved $REPO_ROOT does not look like the repository root." >&2
  exit 1
fi
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
      mkdir -p "$REPO_ROOT/bin"

      # download to a temp file so a failed or truncated response can't leave a
      # broken jq that the "already present" check would then skip. the EXIT trap
      # removes the temp file if the run is interrupted before the move.
      #
      # --retry covers timeouts and HTTP 408/429/5xx. --retry-all-errors is
      # required for a dropped connection (curl 56), and with -f it also retries
      # 4xx. --connect-timeout bounds a hung connect. --speed-limit 1024 and
      # --speed-time 30 abort a transfer slower than 1024 bytes/s for 30
      # seconds, so a stall is retryable without capping a slow but progressing
      # download.
      #
      # --retry-max-time only limits when a new retry may start.
      #
      # keep this array in sync with the same flags in scripts/download-scripts.sh
      CURL_RETRY=(
        -fsSL
        --retry 5
        --retry-all-errors
        --retry-delay 2
        --retry-max-time 90
        --connect-timeout 10
        --speed-limit 1024
        --speed-time 30
      )
      tmp=$(mktemp "$REPO_ROOT/bin/jq.XXXXXX")
      trap 'rm -f "$tmp"' EXIT
      # || curl_status=$? keeps going under set -e so the temp file can be removed
      curl_status=0
      curl "${CURL_RETRY[@]}" \
        "https://github.com/jqlang/jq/releases/download/jq-1.7.1/jq-macos-arm64" \
        -o "$tmp" || curl_status=$?
      if [ "$curl_status" -ne 0 ]; then
        rm -f "$tmp"
        trap - EXIT
        exit "$curl_status"
      fi

      # mktemp creates 0600, so chmod +x would leave 0711, and a script can't run
      # without the read bit if another user executes it
      chmod 755 "$tmp"

      mv "$tmp" "$REPO_ROOT/bin/jq"
      trap - EXIT
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
