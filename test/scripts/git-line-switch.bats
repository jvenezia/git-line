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

@test "'git line switch' checkouts selected branch" {
    git checkout -b 'branch'
    git checkout -b 'other_branch'

    echo 2 |git line switch

    current_branch=$(git rev-parse --abbrev-ref HEAD)
    assert_equal "$current_branch" "master"

    echo 1 |git line switch

    current_branch=$(git rev-parse --abbrev-ref HEAD)
    assert_equal "$current_branch" "other_branch"
}