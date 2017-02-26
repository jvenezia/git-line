#!/usr/bin/env bats

source 'test/test_helpers/bats-support/load.bash'
source 'test/test_helpers/bats-assert/load.bash'
source 'test/test_helpers/test_helper.bash'

setup() {
    setup_tests
    create_git_repo
    cd git_repo
}

teardown() {
    clean_tests
}

@test "'git line update' updates DEVELOPMENT_BRANCH from origin, then rebase current branch onto it" {
    git checkout -b feature
    touch new_file
    git add . && git commit -a -m "file"
    git push --set-upstream origin feature

    git checkout master
    touch other_file
    git add . && git commit -a -m "file"
    git push

    git checkout feature

    run git line update

    assert_output --partial "Switched to branch 'master'"
    assert_output --partial "Already up-to-date."
    assert_output --partial "Switched to branch 'feature'"
    assert_output --partial "Applying: file"

    current_branch=$(git rev-parse --abbrev-ref HEAD)
    assert_equal "$current_branch" "feature"
}