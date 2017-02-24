## Git Line

## Installation

Clone this repository and the folder in your PATH.

```bash
cd $HOME
git clone git@github.com:jvenezia/git-extensions.git
echo 'export PATH="$PATH:$HOME/git-extensions/extensions"' >> .zshrc
source .zshrc
```

Add a config file in your git project or in your home directory.

```bash
cp $HOME/git-extensions/.git-extensions.conf.example $HOME/.git-extensions.conf
cp $HOME/git-extensions/.git-extensions.conf.example my-project/.git-extensions.conf
```

You can optionally add aliases:

```bash
echo 'source $HOME/git-extensions/.aliases"' >> .zshrc
```

## Extensions

#### Feature

```
usage: git feature <feature>

Creates a feature branch starting from DEVELOPMENT_BRANCH.
```

#### Fixup

```
usage: git fixup 

Commit with autosquash formated message to fixup the previous commit.
```

#### Squash

```
usage: git squash 

Interactive rebase with autosquash to current branch's oldest ancestor from DEVELOPMENT_BRANCH.
```

#### Update

```
usage: git update 

Updates DEVELOPMENT_BRANCH from origin, then rebase current branch onto it.
```

#### Close

```
usage: git close

Updates DEVELOPMENT_BRANCH to the current branch.
```

#### Nuke

```
usage: git nuke 

Removes current branch locally and from origin. It will not apply to branches listed in PROTECTED_BRANCHES.
```

#### Wipe

```
usage: git wipe

Remove all remote branches removed from origin.
```

## License

Released under the MIT License, which can be found in LICENSE.txt.