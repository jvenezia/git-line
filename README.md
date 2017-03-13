## Git Line

[![Build Status](https://travis-ci.org/jvenezia/git-line.svg?branch=master)](https://travis-ci.org/jvenezia/git-line)

## Installation

Install Git Line scripts:

```bash
curl -s https://raw.githubusercontent.com/jvenezia/git-line/master/installer.bash | bash /dev/stdin install
```

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
usage: git line start <feature>

Creates a feature branch starting from DEVELOPMENT_BRANCH.
```

#### Switch

```
usage: git line switch

Switch between most recent branches.
```

#### Fixup

```
usage: git line fixup 

Commit with autosquash formated message to fixup the previous commit.
```

#### Squash

```
usage: git line squash 

Interactive rebase with autosquash to current branch's oldest ancestor from DEVELOPMENT_BRANCH.
```

#### Update

```
usage: git line update 

Updates DEVELOPMENT_BRANCH from origin, then rebase current branch onto it.
```

#### Close

```
usage: git line close

Updates DEVELOPMENT_BRANCH to the current branch.
```

#### Remove

```
usage: git line remove

Removes current branch locally and from origin. It will not apply to branches listed in PROTECTED_BRANCHES.
```

#### Clean

```
usage: git line clean

Remove all remote branches removed from origin.
```

## Tests

Install [bats](https://github.com/sstephenson/bats/wiki/Install-Bats-Using-a-Package).

Run tests:

```bash
bats test/scripts
```

## License

Released under the MIT License, which can be found in LICENSE.txt.