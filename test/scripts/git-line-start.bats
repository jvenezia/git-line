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

@test "'git line start' creates a feature branch starting from updated DEVELOPMENT_BRANCH" {
    git checkout -b 'other_branch'

    run git line start new_feature

    assert_output --partial "Switched to branch 'master'"
    assert_output --partial "Already up to date."

    current_branch=$(git rev-parse --abbrev-ref HEAD)
    assert_equal "$current_branch" "new_feature"
}

@test "'git line start' with branch prefix" {
    git config git-line.branch-prefix-enabled 'true'
    git config git-line.branch-prefix 'prefix'

    run git line start new_feature

    current_branch=$(git rev-parse --abbrev-ref HEAD)
    assert_equal "$current_branch" "prefix/new_feature"
}

@test "'git line start' displays usage when no feature is provided" {
    run git line start

    assert_equal $status 1
    assert_output --partial 'usage:'
}
