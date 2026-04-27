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

@test "'git line push' sets an upstream and pushes current branch" {
    git checkout -b branch-without-remote

    touch new_file
    git add . && git commit -a -m "new file"

    run git line push

    upstream_branch=$(git rev-parse --abbrev-ref --symbolic-full-name '@{upstream}')

    assert_equal "$status" 0
    assert_output --partial 'branch-without-remote -> branch-without-remote'
    assert_equal "$upstream_branch" "origin/branch-without-remote"
}
