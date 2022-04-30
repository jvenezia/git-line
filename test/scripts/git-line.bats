#!/usr/bin/env bats

source 'test/test_helper/bats-support/load.bash'
source 'test/test_helper/bats-assert/load.bash'
source 'test/test_helper/test_helper.bash'

setup() {
    setup_tests
    create_git_repo
    cd git_repo || exit
}

teardown() {
    clean_tests
}

@test "'git line' displays usage when no command is provided" {
    run git line

    assert_equal $status 1
    assert_output --partial 'usage:'
}
