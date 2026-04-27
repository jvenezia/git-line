#!/usr/bin/env bats

source 'test/test_helper/load_bats_libraries.bash'
source 'test/test_helper/test_helper.bash'

setup() {
    setup_tests
    create_git_repo master
    cd git_repo || exit
}

teardown() {
    clean_tests
}

@test "'git line' displays usage when no command is provided" {
    run git line

    assert_equal "$status" 1
    assert_output --partial 'usage:'
}

@test "'git line' shows an info insight when current branch base has updates" {
    git checkout -b other_branch
    touch file_on_other_branch
    git add . && git commit -a -m "commit on other branch"

    git line start new-branch --from other_branch

    git checkout other_branch
    touch updated_file_on_other_branch
    git add . && git commit -a -m "update other branch"

    git checkout from-other_branch/new-branch

    run git line

    assert_equal "$status" 1
    assert_output --partial 'Base branch "other_branch" has new commits.'
    assert_output --partial "Run \`git line update\` to rebase the current branch."
    assert_output --partial $'current branch.\n\nusage:'
    assert_output --partial 'usage:'
}
