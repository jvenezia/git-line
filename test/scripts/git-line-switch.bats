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

@test "'git line switch' checkouts selected branch" {
    touch old_file
    git add .
    GIT_COMMITTER_DATE="Wed Feb 13 14:00 2016 +0100" git commit -am 'old file'

    git checkout -b 'branch'
    touch new_file
    git add .
    GIT_COMMITTER_DATE="Wed Feb 13 14:00 2018 +0100" git commit -am 'new file'

    echo 1 |git line switch

    current_branch=$(git rev-parse --abbrev-ref HEAD)
    assert_equal "$current_branch" "branch"

    echo 2 |git line switch

    current_branch=$(git rev-parse --abbrev-ref HEAD)
    assert_equal "$current_branch" "master"
}