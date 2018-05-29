#!/usr/bin/env bats

source 'test/test_helpers/bats-support/load.bash'
source 'test/test_helpers/bats-assert/load.bash'
source 'test/test_helpers/test_helper.bash'

setup() {
    setup_tests
    create_git_repo
    cd git_repo || exit
}

teardown() {
    clean_tests
}

@test "'git line start' creates a feature branch starting from updated DEVELOPMENT_BRANCH" {
    touch file_on_master
    git add . && git commit -a -m "commit"
    git push
    git reset --hard HEAD^

    git checkout -b 'other_branch'

    run git line start new-branch

    current_branch=$(git rev-parse --abbrev-ref HEAD)
    assert_equal "$current_branch" "new-branch"
    assert [ -e file_on_master ]
}

@test "'git line start' with uncommited change" {
    touch file_on_master
    git add . && git commit -a -m "commit"
    git push
    git reset --hard HEAD^

    git checkout -b 'other_branch'
    touch uncommited_file
    git add .

    run git line start new-branch

    current_branch=$(git rev-parse --abbrev-ref HEAD)
    assert_equal "$current_branch" "new-branch"
    assert [ -e file_on_master ]

    current_changes=$(git --no-pager diff --name-only --staged)
    assert_equal "$current_changes" "uncommited_file"
}

@test "'git line start' without uncommited change but existing stash" {
    touch other_stashed_file
    git add . && git stash

    touch file_on_master
    git add . && git commit -a -m "commit"
    git push
    git reset --hard HEAD^

    git checkout -b 'other_branch'

    run git line start new-branch

    current_branch=$(git rev-parse --abbrev-ref HEAD)
    assert_equal "$current_branch" "new-branch"
    assert [ -e file_on_master ]

    current_changes=$(git --no-pager diff --name-only --staged)
    assert_equal "$current_changes" ""
}

@test "'git line start' when branch name has spaces" {
    git config git-line.branch-prefix-enabled 'true'
    git config git-line.branch-prefix 'prefix'

    run git line start " new branch "

    current_branch=$(git rev-parse --abbrev-ref HEAD)
    assert_equal "$current_branch" "prefix/new-branch"
}

@test "'git line start' with branch prefix" {
    git config git-line.branch-prefix-enabled 'true'
    git config git-line.branch-prefix 'prefix'

    run git line start new-branch

    current_branch=$(git rev-parse --abbrev-ref HEAD)
    assert_equal "$current_branch" "prefix/new-branch"
}

@test "'git line start' displays usage when no branch name is provided" {
    run git line start

    assert_equal $status 1
    assert_output --partial 'usage:'
}

@test "'git line start' displays usage when too many arguments are provided" {
    run git line start too many

    assert_equal $status 1
    assert_output --partial 'usage:'
}
