#!/usr/bin/env bash

INSTALL_PATH="/usr/local/bin"
REPO_NAME="git-line"
REPO="git@github.com:jvenezia/$REPO_NAME.git"

function main() {
    echo "Installing git-extensions to $INSTALL_PATH."
    echo "Cloning repo from GitHub to $REPO_NAME."

    git clone $REPO

    install -v -d -m 0755 "$INSTALL_PATH"

    #TO REMOVE
    previous_path=$PWD
    cd $REPO_NAME
    git checkout "feature/install"

    for script in scripts/*; do
        echo $script
    done

    #TO REMOVE
    cd $previous_path
    ##

    rm -rf git-line
}

main