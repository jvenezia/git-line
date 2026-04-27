#!/usr/bin/env bash

function setup_tests {
    local test_name

    ROOT=$PWD
    test_name=$(basename "${BATS_TEST_FILENAME:-manual}" .bats)
    TEST_TMP_DIR="${TEST_TMPDIR:-/tmp/git-line-tests}/$test_name-${BATS_TEST_NUMBER:-0}"

    ORIGINAL_PATH=$PATH
    export PATH="$PATH:$ROOT/scripts"
    chmod +x $ROOT/scripts/git-line

    rm -fr "$TEST_TMP_DIR"
    mkdir -p "$TEST_TMP_DIR"
    cd "$TEST_TMP_DIR" || exit
}

function clean_tests {
    export PATH=$ORIGINAL_PATH

    cd "$ROOT" || exit
    rm -fr "$TEST_TMP_DIR"
}

function create_git_repo {
    local default_branch

    default_branch=${1:-master}

    if [[ -z $(git config --global user.email) ]]; then
        git config --global user.email "test@test.com"
    fi

    if [[ -z $(git config --global user.name) ]]; then
        git config --global user.name "Test"
    fi

    git init --bare --initial-branch="$default_branch" remote_git_repo.git

    mkdir git_repo
    cd git_repo || exit

    git init --initial-branch="$default_branch"
    git remote add origin ../remote_git_repo.git

    touch "file"
    git add . && git commit -a -m "init"
    git push --set-upstream origin "$default_branch"

    git config git-line.development-branch "$default_branch"
    git config git-line.protected-branches "$default_branch"
    git config git-line.branch-prefix-enabled 'false'

    cd ..
}

function debug {
    run bash -c "echo $1; false"
    echo "==== DEBUG"
    echo "${output}"
    echo "===="
}
