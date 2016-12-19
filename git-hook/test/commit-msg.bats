#!/usr/bin/env bats
load test_helper

setup() {
  mkdir -p "$GIT_TEST_PROJECT_PATH"
  cd "$GIT_TEST_PROJECT_PATH"
  cp "$GIT_SRC_INSTALL_PATH/test/package.json" "$GIT_TEST_PROJECT_PATH/package.json"
  git init
  git config user.email sunnyadi@163.com
  git config user.name wangzengdi
  npm install "$GIT_SRC_PROJECT_PATH" --save
}

@test "commit-msg: master/develop/test/release should not be changed locally." {
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

@test "commit-msg: branch name should contains jira task." {
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

@test "commit-msg: commit message should not be empty." {
  git checkout -b feature/TASK-9527
  git add .
  run git commit -m "#start with # is also an empty line"
  assert_failure "Commit message should not be Empty! Write Sth about the commit. ✏️ "

  run git commit -m "commit message"
  assert_success
}

@test "commit-msg: branch name will not add again if commit message contains it already." {
  git checkout -b feature/TASK-9527
  git add .
  run git commit -m "feature/TASK-9527 branch name alread in commit message"
  assert_success
}

