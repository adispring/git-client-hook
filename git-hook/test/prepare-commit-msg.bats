#!/usr/bin/env bats
load test_helper

setup() {
  mkdir -p "$HOOK_TEST_PATH"
  cd "$HOOK_TEST_PATH"
  cp "$INSTALL_SCRIPT_PATH/test/package.json" "$HOOK_TEST_PATH/package.json"
  git init
  git config user.email sunnyadi@163.com
  npm install "$PROJECT_PATH" --save
}

@test "prepare-commit-msg: master/develop/test/release should not be changed locally." {
  git add .
  run git commit -m "commit message"
  assert_output_contains  "warning: Branch master should not be changed locally! ⛔️ "

  git checkout -b develop
  echo 'develop' > new_file.js
  git add .
  run git commit -m "commit message"
  assert_output_contains  "warning: Branch develop should not be changed locally! ⛔️ "

  git checkout -b release
  echo 'release' > new_file.js
  git add .
  run git commit -m "commit message"
  assert_output_contains  "warning: Branch release should not be changed locally! ⛔️ "

  git checkout -b test
  echo 'test' > new_file.js
  git add .
  run git commit -m "commit message"
  assert_output_contains  "warning: Branch test should not be changed locally! ⛔️ "
}

@test "prepare-commit-msg: branch name should contains jira task." {
  git checkout -b feature/TASK-9527
  git add .
  run git commit -m "commit message"
  assert_success

  git checkout -b no-jira-branch
  echo 'new file' > new_file.js
  git add .
  run git commit -m "commit message"
  assert_output_contains "Branch name: \"no-jira-branch\" does not match JIRA format. Please change it !!! ✏️ "
}

@test "prepare-commit-msg: commit message should not be empty." {
  git checkout -b feature/TASK-9527
  git add .
  run git commit -m ""
  assert_failure "Commit message should not be Empty! Write Sth about the commit. ✏️ "

  run git commit -m "commit message"
  assert_success
}

@test "prepare-commit-msg: branch name will not add again if commit message contains it already." {
  git checkout -b feature/TASK-9527
  git add .
  run git commit -m "feature/TASK-9527 branch name alread in commit message"
  assert_success
}

