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

@test "'git line close' updates DEVELOPMENT_BRANCH to the current branch" {
    git checkout -b feature
    touch new_file
    git add . && git commit -a -m "new file"

    run git line close

    # Assert checkout master
    assert_output --partial "Switched to branch 'master'"

    # Assert git pull
    assert_output --partial "Already up-to-date."

    development_branch_latest_commit=$(git log -n 1 --pretty=%H master)
    feature_branch_latest_commit=$(git log -n 1 --pretty=%H feature)
    assert_equal "$development_branch_latest_commit" "$feature_branch_latest_commit"

    # Assert git push
    assert_output --partial "To ../remote_git_repo.git"

    current_branch=$(git rev-parse --abbrev-ref HEAD)
    assert_equal "$current_branch" "feature"
}