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

@test "'git line clean' removes all remote branches removed from origin" {
    git checkout -b feature
    touch new_file
    git add . && git commit -a -m "file"
    git push --set-upstream origin feature
    git push origin :feature

    run git line clean

    assert_output --partial 'Fetching origin'
}