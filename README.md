
# git-client-hook

git-client-hook is a repository that contains some git client hook.
[git client hook describe link](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks).
It's now used for node project, you can custom it for your project.

## Function of git client hook

### `pre-push`: run npm test before git push

If pre-push's npm test passed, then git push will go on, else if pre-push failure,
git push will be cancelled, and output errors npm found.

### `prepare-commit-msg`: add branch name(jira) to commit message automatically & do some check

Your branch name should have format like `feature/TASK-[1234]` or `bugfix/TASK-[1234]`.
When run git commit, prepare-commit-msg hook will add branch name(jira task number) to
commit message prepend.
[The function of JIRA Task number in commit message](https://confluence.atlassian.com/display/FISHEYE/Using+Smart+Commits): can build a link between git commit and JIRA TASK.

Before add branch name(JIRA TASK number) to commit message, there are some checks,

Check options includes:

1. if commit on branch: master/develop/release/test, it will output a warning.
2. if commit without any message, this commit will fail.
3. if commit message already contains a jira task number, it will not add one again.
If all above passed, prepare-commit-msg will add branch name(JIRA TASK number) to commit message.

## Installing git-client-hook

Run `npm install git-client-hook --save`, pre-push & prepare-commit-msg hooks
will install into `git/hooks`.

Before install git hooks to `.git/hooks`, there are also some checks,

Check options includes:

1. git hook will install only if NODE_ENV is development or undefined.
2. if the project is managed by git.(has .git/ dir) 
3. whether some hooks have already installed, whether hooks have changed/updated. If hook has already installed and not changed, this hook will not install again, else if it updated, it will updated.

## Development

You can add any fantasy git client hooks to the repository, or custom it for your project.

Tests are executed using [Bats](https://github.com/sstephenson/bats):

    $ bats git-hook/test
    $ bats git-hook/test/<file>.bats

Please feel free to submit pull requests and file bugs on the [issue
tracker](https://github.com/adispring/git-client-hook/issues).

## TODO

1. add post-commit to run npm test in background
2. add git-hook CLI: 1.custom pre-commit email verify; 2.batch change current branch commits email 
3. update git unit test for new git-hook-install.sh
