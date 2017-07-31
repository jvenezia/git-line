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

@test "'git line finish' squash all commits into one on DEVELOPMENT_BRANCH" {
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

    run git line finish

    current_branch=$(git rev-parse --abbrev-ref HEAD)
    assert_equal $current_branch "master"

    current_commit_message=$(git log -1 --pretty=%B)
    assert_equal 'feature branch branch branch' $current_commit_message

    previous_master_commit=$(git log master~1 -1 --oneline)
    origin_master_commit=$(git log origin/master -1 --oneline)
    assert_equal $previous_master_commit $origin_master_commit
}