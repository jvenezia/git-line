#!/usr/bin/env bats

load '/usr/local/lib/bats-support/load.bash'
load '/usr/local/lib/bats-assert/load.bash'

source 'tests/test_helper.sh'

setup() {
    setup_tests
    create_git_repo
    cd git_repo
}

teardown() {
    clean_tests
}

@test "'git line start' creates a feature branch starting from updated DEVELOPMENT_BRANCH" {
    git checkout -b 'other_branch'

    run git line start new_feature

    assert_output --partial "Switched to branch 'master'"
    assert_output --partial "Already up-to-date."

    current_branch=$(git rev-parse --abbrev-ref HEAD)
    assert_equal $current_branch 'feature/new_feature'
}