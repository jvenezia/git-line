#!/usr/bin/env bats

source 'test/test_helper/bats-support/load.bash'
source 'test/test_helper/bats-assert/load.bash'
source 'test/test_helper/test_helper.bash'

setup() {
    setup_tests
    create_git_repo
    cd git_repo || exit
}

teardown() {
    clean_tests
}

@test "'git line update' updates DEVELOPMENT_BRANCH from origin, then rebase current branch onto it" {
    # Given
    # Committing on master...
    git checkout master
    touch other_file
    git add . && git commit -a -m "commit on master"
    git push

    # Reverting local repo to previous commit...
    git reset --hard HEAD^

    # Committing on a new feature branch...
    git checkout -b feature
    touch new_file
    git add . && git commit -a -m "commit on feature branch"

    # When
    run git line update

    # Then
    # Current branch should be the feature branch...
    current_branch=$(git rev-parse --abbrev-ref HEAD)
    assert_equal $current_branch "feature"

    # Local master branch should be updated to the origin master branch...
    master_commit=$(git log master -1 --oneline)
    origin_master_commit=$(git log origin/master -1 --oneline)
    assert_equal "\"${master_commit}\"" "\"${origin_master_commit}\""

    # Previous commit on the feature branch should be the last master branch commit...
    previous_commit=$(git log HEAD~1 -1 --oneline)
    assert_equal "\"${previous_commit}\"" "\"${master_commit}\""
}
