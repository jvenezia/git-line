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

@test "'git line commit' commit all changes with a message and an extra empty commit" {
    # Given
    git checkout -b new_branch

    touch other_file
    echo "change" >> other_file

    # When
    git line commit "New commit."

    # Then
    new_commit=$(git log new_branch -2 --oneline | tail -n1 | sed 's/[^ ]* *//')
    assert_equal "$new_commit" "New commit."

    empty_commit=$(git log new_branch -1 --oneline | tail -n1 | sed 's/[^ ]* *//')
    assert_equal "$empty_commit" "Empty commit to force Github 'Squash and merge' to use PR title as commit message."
}

@test "'git line commit' commit all changes with a message without empty commit" {
    # Given
    git checkout -b new_branch

    touch other_file

    echo "first change" >> other_file
    git add . && git commit -am "First commit."

    echo "second change" >> other_file
    git add . && git commit -am "Second commit."

    echo "new change" >> other_file

    # When
    git line commit "New commit."

    first_commit=$(git log new_branch -3 --oneline | tail -n1 | sed 's/[^ ]* *//')
    assert_equal "$first_commit" "First commit."

    second_commit=$(git log new_branch -2 --oneline | tail -n1 | sed 's/[^ ]* *//')
    assert_equal "$second_commit" "Second commit."

    new_commit=$(git log new_branch -1 --oneline | tail -n1 | sed 's/[^ ]* *//')
    assert_equal "$new_commit" "New commit."
}
