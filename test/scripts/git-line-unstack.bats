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

@test "'git line unstack' rebases a stacked branch onto DEVELOPMENT_BRANCH" {
    git checkout -b other_branch
    touch file_on_other_branch
    git add . && git commit -a -m "commit on other branch"

    git line start new-branch --from other_branch
    touch file_on_new_branch
    git add . && git commit -a -m "commit on new branch"

    git checkout master
    git merge --squash other_branch
    git commit -m "squash merge other branch"

    git checkout from-other_branch/new-branch

    run git line unstack

    assert_equal "$status" 0

    current_branch=$(git rev-parse --abbrev-ref HEAD)
    assert_equal "$current_branch" "from-other_branch/new-branch"

    base_branch=$(git config "branch.$current_branch.git-line-base-branch")
    assert_equal "$base_branch" "master"

    master_commit=$(git log master -1 --oneline)
    previous_commit=$(git log HEAD~1 -1 --oneline)
    assert_equal "\"${previous_commit}\"" "\"${master_commit}\""

    run git merge-base --is-ancestor other_branch HEAD
    assert_equal "$status" 1
}

@test "'git line unstack' accepts an explicit base branch" {
    git checkout -b other_branch
    touch file_on_other_branch
    git add . && git commit -a -m "commit on other branch"

    git line start new-branch --from other_branch
    touch file_on_new_branch
    git add . && git commit -a -m "commit on new branch"

    git checkout master
    git checkout -b release
    touch file_on_release
    git add . && git commit -a -m "commit on release"

    git checkout from-other_branch/new-branch

    run git line unstack release

    assert_equal "$status" 0

    current_branch=$(git rev-parse --abbrev-ref HEAD)
    base_branch=$(git config "branch.$current_branch.git-line-base-branch")
    assert_equal "$base_branch" "release"

    release_commit=$(git log release -1 --oneline)
    previous_commit=$(git log HEAD~1 -1 --oneline)
    assert_equal "\"${previous_commit}\"" "\"${release_commit}\""
}

@test "'git line unstack' displays usage when too many arguments are provided" {
    run git line unstack master release

    assert_equal "$status" 1
    assert_output --partial 'usage:'
}
