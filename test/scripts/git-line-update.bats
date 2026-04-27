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
    assert_equal "$current_branch" "feature"

    # Local master branch should be updated to the origin master branch...
    master_commit=$(git log master -1 --oneline)
    origin_master_commit=$(git log origin/master -1 --oneline)
    assert_equal "\"${master_commit}\"" "\"${origin_master_commit}\""

    # Previous commit on the feature branch should be the last master branch commit...
    previous_commit=$(git log HEAD~1 -1 --oneline)
    assert_equal "\"${previous_commit}\"" "\"${master_commit}\""
}

@test "'git line update' updates a stacked branch base from origin, then rebase current branch onto it" {
    git checkout -b other_branch
    touch file_on_other_branch
    git add . && git commit -a -m "commit on other branch"
    git push --set-upstream origin other_branch

    git line start new-branch --from other_branch
    touch file_on_new_branch
    git add . && git commit -a -m "commit on new branch"

    git checkout other_branch
    touch updated_file_on_other_branch
    git add . && git commit -a -m "update other branch"
    git push
    git reset --hard HEAD^

    git checkout from-other_branch/new-branch

    run git line update

    current_branch=$(git rev-parse --abbrev-ref HEAD)
    assert_equal "$current_branch" "from-other_branch/new-branch"

    other_branch_commit=$(git log other_branch -1 --oneline)
    origin_other_branch_commit=$(git log origin/other_branch -1 --oneline)
    assert_equal "\"${other_branch_commit}\"" "\"${origin_other_branch_commit}\""

    previous_commit=$(git log HEAD~1 -1 --oneline)
    assert_equal "\"${previous_commit}\"" "\"${other_branch_commit}\""
}

@test "'git line update' updates a stacked branch base from its configured upstream" {
    git init --bare --initial-branch=master ../upstream_git_repo.git
    git remote add upstream ../upstream_git_repo.git

    git checkout -b other_branch
    touch file_on_other_branch
    git add . && git commit -a -m "commit on other branch"
    git push --set-upstream upstream other_branch

    git line start new-branch --from other_branch
    touch file_on_new_branch
    git add . && git commit -a -m "commit on new branch"

    git checkout other_branch
    touch updated_file_on_other_branch
    git add . && git commit -a -m "update other branch"
    git push upstream other_branch
    git reset --hard HEAD^

    git checkout from-other_branch/new-branch

    run git line update

    current_branch=$(git rev-parse --abbrev-ref HEAD)
    assert_equal "$current_branch" "from-other_branch/new-branch"

    other_branch_commit=$(git log other_branch -1 --oneline)
    upstream_other_branch_commit=$(git log upstream/other_branch -1 --oneline)
    assert_equal "\"${other_branch_commit}\"" "\"${upstream_other_branch_commit}\""

    previous_commit=$(git log HEAD~1 -1 --oneline)
    assert_equal "\"${previous_commit}\"" "\"${other_branch_commit}\""
}
