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
    git push --set-upstream origin from-other_branch/new-branch

    git checkout master
    git merge --squash other_branch
    git commit -m "squash merge other branch"

    git checkout from-other_branch/new-branch

    run git line unstack

    assert_equal "$status" 0

    current_branch=$(git rev-parse --abbrev-ref HEAD)
    assert_equal "$current_branch" "from-master/new-branch"

    base_branch=$(git config "branch.$current_branch.git-line-base-branch")
    assert_equal "$base_branch" "master"

    master_commit=$(git log master -1 --oneline)
    previous_commit=$(git log HEAD~1 -1 --oneline)
    assert_equal "\"${previous_commit}\"" "\"${master_commit}\""

    run git merge-base --is-ancestor other_branch HEAD
    assert_equal "$status" 1

    run git rev-parse --abbrev-ref --symbolic-full-name '@{u}'
    assert [ "$status" -ne 0 ]
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
    assert_equal "$current_branch" "from-release/new-branch"

    base_branch=$(git config "branch.$current_branch.git-line-base-branch")
    assert_equal "$base_branch" "release"

    release_commit=$(git log release -1 --oneline)
    previous_commit=$(git log HEAD~1 -1 --oneline)
    assert_equal "\"${previous_commit}\"" "\"${release_commit}\""
}

@test "'git line unstack' preserves the existing branch prefix when renaming" {
    git config git-line.branch-prefix-enabled 'true'
    git config git-line.branch-prefix 'prefix'

    git checkout -b prefix/from-master/other_branch
    touch file_on_other_branch
    git add . && git commit -a -m "commit on other branch"

    git line start new-branch --from prefix/from-master/other_branch
    touch file_on_new_branch
    git add . && git commit -a -m "commit on new branch"

    git checkout master
    git merge --squash prefix/from-master/other_branch
    git commit -m "squash merge other branch"

    git checkout prefix/from-other_branch/new-branch

    run git line unstack

    assert_equal "$status" 0

    current_branch=$(git rev-parse --abbrev-ref HEAD)
    assert_equal "$current_branch" "prefix/from-master/new-branch"

    base_branch=$(git config "branch.$current_branch.git-line-base-branch")
    assert_equal "$base_branch" "master"
}

@test "'git line unstack' renames a branch when it already has the target base configured" {
    git checkout -b other_branch
    touch file_on_other_branch
    git add . && git commit -a -m "commit on other branch"

    git line start new-branch --from other_branch
    touch file_on_new_branch
    git add . && git commit -a -m "commit on new branch"

    current_branch=$(git rev-parse --abbrev-ref HEAD)
    git config "branch.$current_branch.git-line-base-branch" master

    run git line unstack

    assert_equal "$status" 0

    current_branch=$(git rev-parse --abbrev-ref HEAD)
    assert_equal "$current_branch" "from-master/new-branch"
}

@test "'git line unstack' refuses to rebase when the renamed branch already exists" {
    git checkout -b other_branch
    touch file_on_other_branch
    git add . && git commit -a -m "commit on other branch"

    git line start new-branch --from other_branch
    touch file_on_new_branch
    git add . && git commit -a -m "commit on new branch"

    original_head=$(git rev-parse HEAD)

    git checkout master
    git branch from-master/new-branch
    git checkout from-other_branch/new-branch

    run git line unstack

    assert_equal "$status" 1
    assert_output --partial 'already exists'

    current_branch=$(git rev-parse --abbrev-ref HEAD)
    assert_equal "$current_branch" "from-other_branch/new-branch"

    current_head=$(git rev-parse HEAD)
    assert_equal "$current_head" "$original_head"
}

@test "'git line unstack' displays usage when too many arguments are provided" {
    run git line unstack master release

    assert_equal "$status" 1
    assert_output --partial 'usage:'
}
