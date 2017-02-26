#!/usr/bin/env bash

function setup_tests {
    ROOT=$PWD

    ORIGINAL_PATH=$PATH
    export PATH="$PATH:$ROOT/scripts"
    chmod +x $ROOT/scripts/git-line

    rm -fr test/tmp
    mkdir test/tmp
    cd test/tmp
}

function clean_tests {
    export PATH=$ORIGINAL_PATH

    rm -fr $ROOT/test/tmp
}

function create_git_repo {
    git config --global user.email "test@test.com"
    git config --global user.name "Test"

    git init --bare remote_git_repo.git

    mkdir git_repo
    cd git_repo

    git init
    git remote add origin ../remote_git_repo.git

    touch "file"
    git add . && git commit -a -m "init"
    git push --set-upstream origin master

    git config git-line.development-branch 'master'
    git config git-line.protected-branches 'master'

    cd ..
}

function debug {
    run bash -c "echo $1; false"
    echo "==== DEBUG"
    echo "${output}"
    echo "===="
}