#!/usr/bin/env bats

source "tests/test_helper.sh"

setup() {
    setup_tests
    create_git_repo
    cd git_repo
}

teardown() {
    clean_tests
}

@test "'git line start' creates a feature branch starting from DEVELOPMENT_BRANCH" {
    git line start new_feature

    current_branch=$(git rev-parse --abbrev-ref HEAD)
    [[ $current_branch == 'feature/new_feature' ]]
}