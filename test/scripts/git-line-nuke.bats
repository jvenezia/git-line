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

@test "'git line nuke' removes all remote branches removed from origin" {
    git checkout -b branch-without-remote

    git checkout -b branch-with-remote
    git push --set-upstream origin branch-with-remote

    git checkout -b branch-with-gone-remote
    git push --set-upstream origin branch-with-gone-remote
    git push origin :branch-with-gone-remote

    git checkout -b other-branch-with-gone-remote
    git push --set-upstream origin other-branch-with-gone-remote
    git push origin :other-branch-with-gone-remote

    run git line nuke

    branches=$(git branch -a | tr '\n' ' ')
    assert_equal "$branches" "  branch-with-remote   branch-without-remote * master   remotes/origin/branch-with-remote   remotes/origin/master "

    current_branch=$(git rev-parse --abbrev-ref HEAD)
    assert_equal "$current_branch" "master"
}