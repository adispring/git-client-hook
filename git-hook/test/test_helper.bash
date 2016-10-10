#!/usr/bin/env bash

load ../../node_modules/bats-assert/all

# Set path vars
export TESTS_PATH="$BATS_TEST_DIRNAME"
export GIT_SRC_PROJECT_PATH="$(cd "$TESTS_PATH/../.." && pwd)"
export GIT_SRC_INSTALL_PATH="$GIT_SRC_PROJECT_PATH/git-hook"
export GIT_SRC_HOOK_PATH="${GIT_SRC_INSTALL_PATH}/hooks"
export GIT_SRC_TEST_PATH="${GIT_SRC_INSTALL_PATH}/test"

if [ -z "$GIT_TEST_PROJECT_PATH" ]; then
  export GIT_TEST_PROJECT_PATH="$HOME/tmp/git-hook-local-temp"
  export GIT_TEST_INSTALL_PATH="$GIT_TEST_PROJECT_PATH/node_modules/git-client-hook/git-hook"
  export GIT_TEST_HOOK_PATH="$GIT_TEST_INSTALL_PATH/hooks"
  export GIT_TEST_GIT_HOOKS_PATH="$GIT_TEST_PROJECT_PATH/.git/hooks"

  PATH="$GIT_TEST_INSTALL_PATH:$PATH"
  PATH="$GIT_TEST_HOOK_PATH:$PATH"
  export PATH
  export NODE_ENV
fi

teardown() {
  rm -rf "$GIT_TEST_PROJECT_PATH"
}

