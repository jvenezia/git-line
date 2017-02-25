## Git Line

## Installation

```bash
curl -s https://raw.githubusercontent.com/jvenezia/git-line/master/installer.sh | bash /dev/stdin install
```

Add a config file in your git project or in your home directory.

```bash
cp $HOME/git-extensions/.git-extensions.conf.example $HOME/.git-extensions.conf
cp $HOME/git-extensions/.git-extensions.conf.example my-project/.git-extensions.conf
```

You can optionally add aliases in file `.aliases`.

To uninstall:

```bash
curl -s https://raw.githubusercontent.com/jvenezia/git-line/master/installer.sh | bash /dev/stdin uninstall
```

## Commands

#### Start

```
usage: git line start <feature>

Creates a feature branch starting from DEVELOPMENT_BRANCH.
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

## License

Released under the MIT License, which can be found in LICENSE.txt.