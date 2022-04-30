## Git Line

## Installation

Install Git Line scripts:

```bash
curl -s https://raw.githubusercontent.com/jvenezia/git-line/master/installer.bash | bash /dev/stdin install
```

By default, scripts are installed in `$HOME/.local/bin`. Make sure this directory is in your `$PATH`.

When using the commands for the first time, an interactive prompt will show to configure the current git repository.

To configure your current git repository manually:

```bash
git config git-line.development-branch 'develop'
git config git-line.protected-branches 'master develop'

git config git-line.branch-prefix-enabled 'true'
git config git-line.branch-prefix 'feature'
```

You can optionally add aliases in file `.aliases`.

To uninstall:

```bash
curl -s https://raw.githubusercontent.com/jvenezia/git-line/master/installer.bash | bash /dev/stdin uninstall
```

## Commands

#### Start

```
usage: git line start <branch_name>

Creates a feature branch starting from DEVELOPMENT_BRANCH.
```

#### Push

```
usage: git line push

Push the current branch and set an upstream if needed.
```

#### Switch

```
usage: git line switch [<partial_branch_name>]

Lists most recent branches and checkout selected one, or checkouts branch matching <partial_branch_name> if provided.
```

#### Edit

```
usage: git line edit 

Interactive rebase with autosquash to current branch's oldest ancestor from DEVELOPMENT_BRANCH.
```

#### Update

```
usage: git line update 

Updates DEVELOPMENT_BRANCH from origin, then rebase current branch onto it.
```

#### Squash

```
usage: git line squash [<commit_message>]

Squash all commits of current branch into one. It will not apply to branches listed in PROTECTED_BRANCHES.
```

#### Remove

```
usage: git line remove

Removes current branch locally and from origin. It will not apply to branches listed in PROTECTED_BRANCHES.
```

#### Nuke

```
usage: git line nuke

Remove all remote branches removed from origin and all local branches which remote is gone. It will not remove branches which never had remotes.
```

## Tests

Install [bats](https://github.com/bats-core/bats-core/) following this documentation: https://bats-core.readthedocs.io/en/stable/tutorial.html#quick-installation

Run tests:

```bash
./test/bats/bin/bats test/scripts
```

## License

Released under the MIT License, which can be found in LICENSE.txt.
