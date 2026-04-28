## Git Line

## Installation

Install Git Line scripts:

```bash
curl -s https://raw.githubusercontent.com/jvenezia/git-line/HEAD/installer.bash | bash /dev/stdin install
```

By default, scripts are installed in `$HOME/.local/bin`. Make sure this directory is in your `$PATH`.

To install to another directory:

```bash
curl -s https://raw.githubusercontent.com/jvenezia/git-line/HEAD/installer.bash | INSTALL_PATH="$HOME/bin" bash /dev/stdin install
```

When using the commands for the first time, an interactive prompt will show to configure the current git repository.

To configure your current git repository manually:

```bash
git config git-line.development-branch 'develop'
git config git-line.protected-branches 'main master develop'

git config git-line.branch-prefix-enabled 'true'
git config git-line.branch-prefix 'feature'
```

You can optionally add aliases in file `.aliases`.

To uninstall:

```bash
curl -s https://raw.githubusercontent.com/jvenezia/git-line/HEAD/installer.bash | bash /dev/stdin uninstall
```

## Commands

#### Line

```
usage: git line <command>

Shows basic help, the current git-line version, and read-only insights for the current branch.
When the current branch was created from another branch and that base branch has new commits,
Git Line recommends `git line update`.
Use `git line help` or `git line -h` for the same basic help, and `git line --version` for only the version.
Git reserves `git line --help` for manual pages, so inline help uses `git line help` instead.
```

#### Start

```
usage: git line start <branch_name> [--from <base_branch>]

Creates a feature branch starting from <base_branch>, or DEVELOPMENT_BRANCH when omitted.
The generated branch name includes the base branch: `from-<base_branch>/<branch_name>`, or
`<prefix>/from-<base_branch>/<branch_name>` when branch prefixes are enabled.
Spaces and slashes in generated branch name components are converted to hyphens.
```

#### Commit

```
usage: git line commit

Commit all changes with a commit message.
Creates an additional empty commit if its the first commit on the branch. This is useful to force Github to use the PR title when using "Squash and merge".
```

#### Push

```
usage: git line push

Push the current branch and set an upstream if needed.
```

#### Stash

```
usage: git line stash

Stash tracked and untracked changes.
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

Updates the current branch's base from its configured upstream, then rebases current branch onto it.
For branches created by `git line start`, the base comes from the generated `from-<base_branch>` branch name.
Branches without a generated base use DEVELOPMENT_BRANCH.
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

## Contributing

### Install Local Version

From the repository root:

```bash
./installer.bash install
```

By default, this installs the local checkout to `$HOME/.local/bin`. To install
to another directory:

```bash
INSTALL_PATH="$HOME/bin" ./installer.bash install
```

The installer uses the current local checkout when run from this repository.
When run from the downloaded script, it clones the repository from GitHub over
HTTPS into a temporary directory and removes that temporary clone after
installation.

### Tests

Build the Docker image:

```bash
./docker-build
```

Run the full test suite:

```bash
./docker-run test
```

Run static checks:

```bash
./docker-run check
```

Run a focused test file:

```bash
./docker-run test test/scripts/git-line-squash.bats
```

The Docker image pins the test stack in `Dockerfile`:

- bats-core 1.13.0
- bats-support 0.3.0
- bats-assert 2.2.4
- shellcheck 0.9.0-1
- shfmt 3.6.0-1+b2

## License

Released under the MIT License, which can be found in LICENSE.txt.
