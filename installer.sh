#!/usr/bin/env bash

INSTALL_PATH="/usr/local/bin"
REPO_NAME="git-line"
REPO_URL="git@github.com:jvenezia/$REPO_NAME.git"

SCRIPT_FILES="git-close git-feature git-fixup git-nuke git-squash git-update git-wipe"

case $1 in
    install)
        echo "Installing git-line to $INSTALL_PATH."
        echo "Cloning repo from GitHub to $REPO_NAME."

        git clone $REPO_URL

        install -v -d -m 0755 "$INSTALL_PATH"

        for file in $SCRIPT_FILES; do
            install -v -m 0755 "$REPO_NAME/scripts/$file" "$INSTALL_PATH"
        done
        ;;

    uninstall)
        echo "Uninstalling git-line from $INSTALL_PATH."

        for file in $SCRIPT_FILES; do
            rm -v -f "$INSTALL_PATH/$file"
        done
        ;;
esac
