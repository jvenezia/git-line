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

@test "'git line stash' stashes tracked and untracked changes" {
    echo "tracked change" >file
    echo "untracked change" >untracked_file

    run git line stash

    assert_equal "$status" 0
    assert_output --partial "Saved working directory"

    run git status --short

    assert_equal "$status" 0
    assert_output ""

    git stash apply

    assert_equal "$(cat file)" "tracked change"
    assert_equal "$(cat untracked_file)" "untracked change"
}
