#!/usr/bin/env bash

function setup_tests {
    ROOT_PATH=$PWD

    rm -fr tests/tmp
    mkdir tests/tmp
    cd tests/tmp
}

function clean_tests {
    rm -fr $ROOT_PATH/tests/tmp
}

function create_git_repo {
    git init --bare remote_git_repo.git

    mkdir git_repo
    cd git_repo

    git init
    git remote add origin ../remote_git_repo.git

    touch "file"
    git add . && git commit -a -m "init"
    git push --set-upstream origin master

    touch .git-extensions.conf
    echo "PROTECTED_BRANCHES='master'" >> .git-extensions.conf
    echo "DEVELOPMENT_BRANCH='master'" >> .git-extensions.conf

    cd ..
}

function debug {
    run bash -c "echo $1; false"
    echo "${output}"
}