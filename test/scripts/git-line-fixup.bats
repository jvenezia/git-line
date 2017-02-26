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

@test "'git line fixup' commits with autosquash formated message to fixup the previous commit" {
    touch fixup_file

    run git line fixup

    commit_message=$(git log -1 --pretty=%B)
    assert_equal "$commit_message" "fixup! init"
}