#!/usr/bin/env bash

INSTALL_PATH="/usr/local/bin"
REPO_NAME="git-line"
REPO="git@github.com:jvenezia/$REPO_NAME.git"

function main() {
    echo "Installing git-extensions to $INSTALL_PATH."
    echo "Cloning repo from GitHub to $REPO_NAME."

    git clone $REPO

    install -v -d -m 0755 "$INSTALL_PATH"

    for script in $REPO_NAME/scripts/*; do
        install -v -m 0755 $script "$INSTALL_PATH"
    done

    rm -rf git-line
}

main