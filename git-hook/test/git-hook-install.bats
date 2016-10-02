#!/usr/bin/env bats
load test_helper

setup() {
  mkdir -p "$HOOK_TEST_PATH"
  cd "$HOOK_TEST_PATH"
  cp "$INSTALL_SCRIPT_PATH/test/package.json" "$HOOK_TEST_PATH/package.json"
}

@test "git-hook-install: If no .git/ dir exist, hook will not install." {
  run npm install "$PROJECT_PATH" --save
  assert_output_contains "No ${HOOK_TEST_PATH}/.git/hooks exist!"

  git init
  run npm install "$PROJECT_PATH" --save
  refute_output_contains "No ${HOOK_TEST_PATH}/.git/hooks exist!"
}

@test "git-hook-install: Hook will install only when NODE_ENV equals undefined or development" {
  git init
  unset NODE_ENV
  export NODE_ENV
  run npm install "$PROJECT_PATH" --save
  assert_output_contains "GIT LOCAL HOOK install done!  🍻"
  refute_output_contains "No need to install git-hook in NODE_ENV: "
  npm uninstall git-client-hook --save

  NODE_ENV="development"
  export NODE_ENV
  run npm install "$PROJECT_PATH" --save
  refute_output_contains "No need to install git-hook in NODE_ENV: development"
  npm uninstall git-client-hook --save
  
  NODE_ENV="production"
  export NODE_ENV
  run npm install "$PROJECT_PATH" 
  assert_output_contains "No need to install git-hook in NODE_ENV: production."
  npm uninstall git-client-hook --save

  NODE_ENV="release"
  export NODE_ENV
  run npm install "$PROJECT_PATH"
  assert_output_contains "No need to install git-hook in NODE_ENV: release."
}

@test "git-hook-install: Hook will install/update only if there are some new hook files/contents." {
  git init
  NODE_ENV="development"
  export NODE_ENV
  run npm install "$PROJECT_PATH"
  assert_output_contains "GIT LOCAL HOOK installing...! ⚙ "
  assert_output_contains "GIT LOCAL HOOK install done!  🍻"
#  for hook_file in ${HOOK_TEST_FILE_NAMES[@]}
#  do
#    assert_output_contains "$hook_file installing..."
#    assert_output_contains "$hook_file installed!"
#  done

#  echo "#add sth to git_hook" >> "$HOOK_TEST_REPO_PATH/${HOOK_TEST_FILE_NAMES[0]}"
#  run npm install "$PROJECT_PATH"
#  assert_output_contains "${HOOK_TEST_FILE_NAMES[0]} has changed: "
#  assert_output_contains "${HOOK_TEST_FILE_NAMES[0]} updating..."
#  assert_output_contains "${HOOK_TEST_FILE_NAMES[0]} updated!"

}

