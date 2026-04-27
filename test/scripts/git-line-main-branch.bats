#!/usr/bin/env bats

source 'test/test_helper/load_bats_libraries.bash'
source 'test/test_helper/test_helper.bash'

setup() {
    setup_tests
    create_git_repo main
    cd git_repo || exit
}

teardown() {
    clean_tests
}

create_commit_on_origin_main() {
    touch file_on_main
    git add . && git commit -a -m "commit on main"
    git push
    git reset --hard HEAD^
}

@test "'git line start' supports a main development branch" {
    create_commit_on_origin_main

    git checkout -b 'other_branch'

    run git line start new-branch

    current_branch=$(git rev-parse --abbrev-ref HEAD)
    assert_equal "$current_branch" "from-main/new-branch"
    assert [ -e file_on_main ]
}

@test "'git line remove' returns to a main development branch" {
    git checkout -b feature
    touch new_file
    git add . && git commit -a -m "file"
    git push --set-upstream origin feature

    run git line remove

    branches=$(git branch -a | tr '\n' ' ')
    assert_equal "$branches" "* main   remotes/origin/main "

    current_branch=$(git rev-parse --abbrev-ref HEAD)
    assert_equal "$current_branch" "main"
}

@test "'git line update' supports a main development branch" {
    create_commit_on_origin_main

    git checkout -b feature
    touch new_file
    git add . && git commit -a -m "commit on feature branch"

    run git line update

    current_branch=$(git rev-parse --abbrev-ref HEAD)
    assert_equal "$current_branch" "feature"

    main_commit=$(git log main -1 --oneline)
    origin_main_commit=$(git log origin/main -1 --oneline)
    assert_equal "\"${main_commit}\"" "\"${origin_main_commit}\""

    previous_commit=$(git log HEAD~1 -1 --oneline)
    assert_equal "\"${previous_commit}\"" "\"${main_commit}\""
}
