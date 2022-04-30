#!/usr/bin/env bash

function setup_tests {
    ROOT=$PWD

    ORIGINAL_PATH=$PATH
    export PATH="$PATH:$ROOT/scripts"
    chmod +x $ROOT/scripts/git-line

    rm -fr test/tmp
    mkdir test/tmp
    cd test/tmp || exit
}

function clean_tests {
    export PATH=$ORIGINAL_PATH

    rm -fr $ROOT/test/tmp
}

function create_git_repo {
    if [[ -z $(git config --global user.email) ]]; then
        git config --global user.email "test@test.com"
    fi

    if [[ -z $(git config --global user.name) ]]; then
        git config --global user.name "Test"
    fi

    git init --bare remote_git_repo.git

    mkdir git_repo
    cd git_repo || exit

    git init
    git remote add origin ../remote_git_repo.git

    touch "file"
    git add . && git commit -a -m "init"
    git push --set-upstream origin master

    git config git-line.development-branch 'master'
    git config git-line.protected-branches 'master'
    git config git-line.branch-prefix-enabled 'false'

    cd ..
}

function debug {
    run bash -c "echo $1; false"
    echo "==== DEBUG"
    echo "${output}"
    echo "===="
}
