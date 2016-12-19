#!/usr/bin/env bats
load test_helper

setup() {
  mkdir -p "$GIT_TEST_PROJECT_PATH"
  cd "$GIT_TEST_PROJECT_PATH"
  cp "$GIT_SRC_INSTALL_PATH/test/package.json" "$GIT_TEST_PROJECT_PATH/package.json"
}

@test "git-hook-uninstall: If no .git/ dir exist, hook will not uninstall." {
  git init
  npm install "$GIT_SRC_PROJECT_PATH" --save
  rm -rf "$GIT_TEST_PROJECT_PATH/.git"
  run npm uninstall git-client-hook --save
  assert_output_contains "No ${GIT_TEST_PROJECT_PATH}/.git/hooks exist!"
}

@test "git-hook-uninstall: Hook uninstall" {
  git init
  npm install "$GIT_SRC_PROJECT_PATH" --save
  run npm uninstall git-client-hook --save
  assert_output_contains "GIT CLIENT HOOK uninstalling...! ⚙ "
  assert_output_contains "GIT CLIENT HOOK uninstall done!  🗑 "
}

