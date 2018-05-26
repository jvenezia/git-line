#!/usr/bin/env bats

source 'test/test_helpers/bats-support/load.bash'
source 'test/test_helpers/bats-assert/load.bash'
source 'test/test_helpers/test_helper.bash'

setup() {
    setup_tests
    create_git_repo
    cd git_repo || exit
}

teardown() {
    clean_tests
}

@test "'git line edit' interactive rebase with autosquash to current branch's oldest ancestor from DEVELOPMENT_BRANCH" {
    git checkout -b feature
    touch new_file
    git add . && git commit -a -m "file"

    # Prevent git to open an editor by setting GIT_SEQUENCE_EDITOR=:
    GIT_SEQUENCE_EDITOR=: run git line edit

    assert_output --partial 'Successfully rebased and updated refs/heads/feature.'
}
