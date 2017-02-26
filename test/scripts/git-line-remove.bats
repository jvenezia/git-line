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

@test "'git line remove' removes current branch locally and from origin" {
    git checkout -b feature
    touch new_file
    git add . && git commit -a -m "file"
    git push --set-upstream origin feature

    run git line remove

    branches=$(git branch -a | tr '\n' ' ')
    assert_equal $branches '* master   remotes/origin/master '

    current_branch=$(git rev-parse --abbrev-ref HEAD)
    assert_equal $current_branch 'master'
}