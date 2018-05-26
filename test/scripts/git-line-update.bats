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

@test "'git line update' updates DEVELOPMENT_BRANCH from origin, then rebase current branch onto it" {
    git checkout master
    touch other_file
    git add . && git commit -a -m "master commit"
    git push
    git reset --hard HEAD^

    git checkout -b feature
    touch new_file
    git add . && git commit -a -m "feature commit"

    run git line update

    current_branch=$(git rev-parse --abbrev-ref HEAD)
    assert_equal $current_branch "feature"

    master_commit=$(git log master -1 --oneline)
    origin_master_commit=$(git log origin/master -1 --oneline)
    assert_equal $master_commit $origin_master_commit

    previous_commit=$(git log HEAD~1 -1 --oneline)
    assert_equal $previous_commit $master_commit
}
