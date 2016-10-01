#!/usr/bin/env bats
load test_helper

setup() {
  mkdir -p "$HOOK_TEST_PATH"
  cd "$HOOK_TEST_PATH"
  cp "$INSTALL_SCRIPT_PATH/test/package.json" "$HOOK_TEST_PATH/package.json"
}

@test "git-hook-install: If no .git/ dir exist, hook will not install." {
  run npm install git-client-hook --save
  assert_output_contains "No ${HOOK_TEST_PATH}/.git/hooks exist!"

  git init
  run npm install git-client-hook --save
  refute_output_contains "No ${HOOK_TEST_PATH}/.git/hooks exist!"
}

@test "git-hook-install: Hook will install only when NODE_ENV equals undefined or development" {
  git init
  (
    unset NODE_ENV
    export NODE_ENV
    run npm install git-client-hook --save
    assert_output_contains "GIT LOCAL HOOK install done!  🍻"
    refute_output_contains "No need to install git-hook in NODE_ENV: "
  )
  (
    NODE_ENV="development"
    export NODE_ENV
    run npm install git-client-hook --save
    refute_output_contains "No need to install git-hook in NODE_ENV: development"
  )

# NODE_ENV does not work in subshell: git-hook-install.sh, why?
#  NODE_ENV="production" run npm install "$PROJECT_ROOT" 
#  assert_output_contains "No need to install git-hook in NODE_ENV: production."
#
#  NODE_ENV="release" run npm install "$PROJECT_ROOT"
#  assert_output_contains "No need to install git-hook in NODE_ENV: release."
}

@test "git-hook-install: Hook will install/update only if there are some new hook files/contents." {
  git init
  (
    NODE_ENV="development"
    export NODE_ENV
    run npm install git-client-hook --save
    assert_output_contains "GIT LOCAL HOOK installing...! ⚙ "
    assert_output_contains "GIT LOCAL HOOK install done!  🍻"
  )
#  for hook_file in ${HOOK_TEST_FILE_NAMES[@]}
#  do
#    assert_output_contains "$hook_file installing..."
#    assert_output_contains "$hook_file installed!"
#  done

#  echo "#add sth to git_hook" >> "$HOOK_TEST_REPO_PATH/${HOOK_TEST_FILE_NAMES[0]}"
#  run npm install git-client-hook --save
#  assert_output_contains "${HOOK_TEST_FILE_NAMES[0]} has changed: "
#  assert_output_contains "${HOOK_TEST_FILE_NAMES[0]} updating..."
#  assert_output_contains "${HOOK_TEST_FILE_NAMES[0]} updated!"

#  run npm install "$PROJECT_ROOT"
#  assert_output_contains "No git hook need to update or install."
}

@test "git-hook-install: install bats & bats-assert." {
  git init

  NODE_ENV="development" run npm install git-client-hook --save
  assert_output_contains "bats installing."
  assert_output_contains "bats installed."
  assert_output_contains "bats-assert installing."
  assert_output_contains "bats-assert installed."

  run npm install git-client-hook --save
  refute_output_contains "bats installing."
  refute_output_contains "bats installed."
  refute_output_contains "bats-assert installing."
  refute_output_contains "bats-assert installed."
}

