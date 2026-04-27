# AGENTS

This document sets expectations for agents contributing to this repository.

## Project Overview

git-line is a small Bash-based Git CLI extension. User-facing commands live in
`scripts/`, shared Bash helpers live in `scripts/git-line_utils.bash`, the
installer is `installer.bash`, and Bats tests live in `test/scripts/`.

## Mandatory Checks Before Any Answer

After making changes:

1. Review your own changes for compliance with this document.
2. For dependency or Dockerfile changes, rebuild the dev image:

   `./docker-build`

3. For code or behavior changes, run the Bats test suite through Docker:

   `./docker-run test`

   For focused debugging, use `./docker-run test path/to/file.bats`, then run the
   full suite before finishing.
4. For documentation-only changes, tests are not required. State explicitly that
   no executable code changed.

Fix any failures before considering the task complete.

## Coding Guidelines

- Clarity: write for readers; keep behavior simple and predictable.
- Shell style: follow the existing Bash style in `scripts/` and `test/`.
- Naming: use explicit, intention-revealing names; avoid unclear abbreviations.
- Functions: keep them small, single-purpose, and early-returning where useful.
- Quoting: quote variable expansions and paths unless word splitting is
  intentional and locally obvious.
- Git safety: be conservative with commands that rewrite history, delete
  branches, remove remotes, or discard local changes.
- Dependencies: keep test tooling pinned in `Dockerfile`; do not require local
  Bats installation or local submodule checkout for normal validation.
- Comments and docs: prefer self-explanatory code. Do not leave comments about
  removed code or rejected alternatives.
- Documentation: update `README.md` when user-facing commands, configuration,
  installation, or usage text changes.

## Tests

- Keep tests fast, deterministic, and behavior-focused.
- Place command tests under `test/scripts/`, matching the command being tested.
- Use the existing helpers in `test/test_helper/test_helper.bash` for temporary
  repositories and cleanup.
- Assert externally visible behavior: exit status, output, current branch,
  repository state, commits, remotes, and files.
- Add or update regression coverage for bug fixes before changing behavior when
  a focused test can reproduce the issue.

## Installer And Commands

- When adding, removing, or renaming a command script, keep `SCRIPT_FILES` in
  `installer.bash` in sync.
- Keep `usage:` output and `README.md` command descriptions aligned with command
  behavior.
- Preserve protection for configured protected branches unless the requested
  change is explicitly about that behavior.

## Misc Notes

- Keep changes minimal and focused; prefer fixing root causes over band-aids.
- Prefer existing project conventions over introducing new structure.
- Avoid broad refactors, renames, or formatting churn unless they are needed for
  the requested change.
- Start responses with substance. Do not begin with filler phrases like
  "Good call", "Nice catch", "Great", "Sure", or "Alright".
