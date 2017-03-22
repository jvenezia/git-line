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

create_commits_and_branches() {
    touch old_file
    git add .
    GIT_COMMITTER_DATE="Wed Feb 13 14:00 2016 +0100" git commit -am 'old file commit'

    git checkout -b 'branch'
    touch new_file
    git add .
    GIT_COMMITTER_DATE="Wed Feb 13 14:00 2018 +0100" git commit -am 'new file commit'

    touch file_to_stash
    git add .
}

@test "'git line switch' checkouts selected branch" {
    create_commits_and_branches

    echo 2 |git line switch

    current_branch=$(git rev-parse --abbrev-ref HEAD)
    assert_equal "$current_branch" "master"

    echo 1 |git line switch

    current_branch=$(git rev-parse --abbrev-ref HEAD)
    assert_equal "$current_branch" "branch"
}

@test "'git line switch' ignores non digit reply" {
    create_commits_and_branches

    echo "a" |git line switch

    current_branch=$(git rev-parse --abbrev-ref HEAD)
    assert_equal "$current_branch" "branch"
}