#!/usr/bin/env bats
load test_helper

setup() {
  mkdir -p "$HOOK_TEST_PATH"
  cd "$HOOK_TEST_PATH"
  cp "$INSTALL_SCRIPT_PATH/test/package.json" "$HOOK_TEST_PATH/package.json"
}

@test "git-hook-uninstall: If no .git/ dir exist, hook will not uninstall." {
  git init
  npm install "$PROJECT_PATH" --save
  rm -rf "$HOOK_TEST_PATH/.git"
  run npm uninstall git-client-hook --save
  assert_output_contains "No ${HOOK_TEST_PATH}/.git/hooks exist!"
}

@test "git-hook-uninstall: Hook uninstall" {
  git init
  npm install "$PROJECT_PATH" --save
  run npm uninstall git-client-hook --save
  assert_output_contains "GIT LOCAL HOOK uninstalling...! ⚙ "
  assert_output_contains "GIT LOCAL HOOK uninstall done!  🗑 "
}

