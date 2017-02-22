## Git Extensions

## Installation

Clone this repository and the folder in your PATH.

```bash
cd $HOME
git clone git@github.com:jvenezia/git-extensions.git
echo 'export PATH="$PATH:$HOME/git-extensions"' >> .zshrc
source .zshrc
```

Add a config file in your git project or in your home directory.

```bash
cp $HOME/git-extensions/.git-extensions.conf.example $HOME/.git-extensions.conf
cp $HOME/git-extensions/.git-extensions.conf.example my-project/.git-extensions.conf
```

## Extensions

#### Fixup

Commit with autosquash formated message.
If no commit is specified, it will use the previous commit. 

Usage:
```
git squash [<commit>]
```

Examples:
```bash
git fixup
git fixup HEAD^
git fixup 541afa9e
```

#### Squash

Interactive rebase with autosquash to the specified commit.
If no commit is specified, it will use current branch's oldest ancestor from DEVELOPMENT_BRANCH.

Usage:
```
git squash [<commit>]
```

Examples:
```bash
git squash
git squash HEAD^
git squash 541afa9e
```

#### Update

Updates target branch from origin, then rebase current branch onto it.
If no base is specified, it will rebase on DEVELOPMENT_BRANCH.

Usage:
```
git update [<base>]
```

Examples:
```bash
git update
git update develop
```

#### Remove Branch

Removes specified branch locally and from origin.
If no branch is specified, it will remove the current branch.

Usage:
```
git rm-branch [<branch>]
```

Examples:
```bash
git rm-branch
git rm-branch feature
```

#### Clean Repo

Remove all remote branches removed from origin.

Usage:
```
git clean-repo
```

## License

Released under the MIT License, which can be found in LICENSE.txt.