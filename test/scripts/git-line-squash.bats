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

@test "'git line squash' squash all commits of current branch into one. It will not apply to branches listed in PROTECTED_BRANCHES." {
    git checkout master
    touch other_file
    git add . && git commit -a -m "master commit"
    git push
    git reset --hard HEAD^

    git checkout -b feature/branch-branch_branch
    touch file_1
    git add . && git commit -a -m "feature commit 1"
    touch file_2
    git add . && git commit -a -m "feature commit 2"
    git push --set-upstream origin feature/branch-branch_branch

    run git line squash

    current_commit_message=$(git log -1 --pretty=%B)
    assert_equal $current_commit_message 'feature branch branch branch'
}

@test "'git line squash' using a commit message" {
    git checkout master
    touch other_file
    git add . && git commit -a -m "master commit"
    git push
    git reset --hard HEAD^

    git checkout -b feature/branch-branch_branch
    touch file_1
    git add . && git commit -a -m "feature commit 1"
    touch file_2
    git add . && git commit -a -m "feature commit 2"
    git push --set-upstream origin feature/branch-branch_branch

    run git line squash "commit message"

    current_commit_message=$(git log -1 --pretty=%B)
    assert_equal $current_commit_message 'commit message'
}
