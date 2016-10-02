
# git-client-hook

git-client-hook used for installing some git client hook into node project.
[git client hook describe link](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks).

## Function of git client hook

### `pre-push`: run npm test before git push

If `npm test` passed, git push will go on, else git push will be cancelled,
and output errors npm test found.

### `prepare-commit-msg`: add branch name(jira) to commit message automatically & do some check

1. Check if commit-msg is valid, check options as follows:

* if commit on branch: **master/develop/release/test**, it will output a warning.
* if **commit without any message**, this commit will fail.
* if commit message already contains a jira task number, it will not add one again.

```
JIRA TASK number regex: [A-Z][A-Z_0-9]+-[0-9]+
```

2. Add JIRA TASK number(branch name) to commit-msg.

If all above passed, **prepare-commit-msg will add branch name(JIRA TASK number) to commit message**.

[The function of JIRA Task number in commit message](https://confluence.atlassian.com/display/FISHEYE/Using+Smart+Commits): can build a link between git commit and JIRA TASK.

## HOW TO USE git-client-hook

### Install

Run `npm install git-client-hook --save`, pre-push & prepare-commit-msg hooks
will install into `git/hooks`.

Before install git hooks to `.git/hooks`, there are also some checks,

Check options includes:

1. Git hook will install only if NODE_ENV is development or undefined.
2. If project is managed by git.(has .git/ dir) 
3. Check if some hooks have already installed, if hooks have changed/updated.
If hook has already installed and not changed, this hook will not install again,
else if it updated, it will updated.

### Uninstall

Run `npm uninstall git-client-hook --save`:

1. git-client-hook will be uninstalled.
2. git hooks installed into .git/hooks/ will be uninstalled.

## Development

You can add any fantasy git client hooks to the repository, or custom it for your project.

Tests are executed using [Bats](https://github.com/sstephenson/bats)

Please feel free to submit pull requests and file bugs on the [issue
tracker](https://github.com/adispring/git-client-hook/issues).

## TODO

1. add post-commit to run npm test in background
2. add git-hook CLI: 1.custom pre-commit email verify; 2.batch change current branch commits email 
5. add git hook update unit-test.

## DONE

v0.0.4 :

1. update git unit test for new git-hook-install.sh

v0.0.5 :

1. remove bats & bats-assert from git-hook-install.sh

v0.0.6

1. uninstall git hooks from .git/hooks/ when uninstall git-client-hook
2. fix NODE_ENV does not work when bash git-hook-install.sh.

