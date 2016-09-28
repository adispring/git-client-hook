#!/usr/bin/env bash

load ../../node_modules/bats-assert/all

# Set path vars
export TESTS_PATH="$BATS_TEST_DIRNAME"
export PROJECT_PATH="$(cd "$TESTS_PATH/../.." && pwd)"
export INSTALL_SCRIPT_PATH="$PROJECT_PATH/git-hook"

if [ -z "$HOOK_TEST_PATH" ]; then
  export HOOK_TEST_PATH="$HOME/tmp/git-hook-local-temp"
  export HOOK_TEST_INSTALL_PATH="$HOOK_TEST_PATH/git-hook"
  export HOOK_TEST_REPO_PATH="$HOOK_TEST_PATH/git-hook/hooks"

  PATH="$HOOK_TEST_INSTALL_PATH:$PATH"
  PATH="$HOOK_TEST_REPO_PATH:$PATH"
  export PATH
  export NODE_ENV
fi

teardown() {
  rm -rf "$HOOK_TEST_PATH"
}

