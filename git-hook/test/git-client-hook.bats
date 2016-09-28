#!/usr/bin/env bats
load test_helper

setup() {
  mkdir -p "$HOOK_TEST_PATH"
  cd "$HOOK_TEST_PATH"
  cp -rf "$INSTALL_SCRIPT_PATH" "$HOOK_TEST_PATH"
  cp "$HOOK_TEST_INSTALL_PATH/test/package.json" "$HOOK_TEST_PATH/package.json"
  cp -rf "$HOOK_TEST_INSTALL_PATH/test/node_modules" "$HOOK_TEST_PATH"
  chmod a+x "${HOOK_TEST_INSTALL_PATH}/git-hook-install.sh"
}

@test "git-hook-install: If no .git/ dir exist, hook will not install." {
  run git-hook-install.sh
  assert_success "No ${HOOK_TEST_PATH}/.git/hooks exist!"

  git init
  run git-hook-install.sh
  refute_output_contains "No ${HOOK_TEST_PATH}/.git/hooks exist!"
}

@test "git-hook-install: Hook will install only when NODE_ENV equals undefined or development" {
  git init
  (
    unset NODE_ENV
    export NODE_ENV
    run git-hook-install.sh
    refute_output_contains "No need to install git-hook in NODE_ENV: "
  )
  NODE_ENV="development" run git-hook-install.sh
  refute_output_contains "No need to install git-hook in NODE_ENV: "

  NODE_ENV="production" run git-hook-install.sh
  assert_output "No need to install git-hook in NODE_ENV: production."

  NODE_ENV="release" run git-hook-install.sh
  assert_output "No need to install git-hook in NODE_ENV: release."
}

@test "git-hook-install: Hook will install/update only if there are some new hook files/contents." {
  git init

  HOOK_TEST_FILE_NAMES=($(ls $HOOK_TEST_REPO_PATH))
  NODE_ENV="development" run git-hook-install.sh
  assert_output_contains "GIT LOCAL HOOK installing...! ⚙ "
  assert_output_contains "GIT LOCAL HOOK install done!  🍻"
  for hook_file in ${HOOK_TEST_FILE_NAMES[@]}
  do
    assert_output_contains "$hook_file installing..."
    assert_output_contains "$hook_file installed!"
  done

  echo "#add sth to git_hook" >> "$HOOK_TEST_REPO_PATH/${HOOK_TEST_FILE_NAMES[0]}"
  run git-hook-install.sh
  assert_output_contains "${HOOK_TEST_FILE_NAMES[0]} has changed: "
  assert_output_contains "${HOOK_TEST_FILE_NAMES[0]} updating..."
  assert_output_contains "${HOOK_TEST_FILE_NAMES[0]} updated!"

  run git-hook-install.sh
  assert_output_contains "No git hook need to update or install."
}

@test "git-hook-install: install bats & bats-assert." {
  rm -rf "$HOOK_TEST_PATH/node_modules"
  git init

  HOOK_TEST_FILE_NAMES=($(ls $HOOK_TEST_REPO_PATH))
  NODE_ENV="development" run git-hook-install.sh
  assert_output_contains "bats installing."
  assert_output_contains "bats installed."
  assert_output_contains "bats-assert installing."
  assert_output_contains "bats-assert installed."

  run git-hook-install.sh
  refute_output_contains "bats installing."
  refute_output_contains "bats installed."
  refute_output_contains "bats-assert installing."
  refute_output_contains "bats-assert installed."
}

@test "git-hook-install: failure if project not contains package.json." {
  git init

  rm "$HOOK_TEST_PATH/package.json"
  HOOK_TEST_FILE_NAMES=($(ls $HOOK_TEST_REPO_PATH))
  NODE_ENV="development" run git-hook-install.sh
  assert_failure  "Node project does not have package.json !"
}
