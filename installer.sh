#!/usr/bin/env bash

INSTALL_PATH="/usr/local/bin"
REPO_NAME="git-line"
REPO_URL="git@github.com:jvenezia/$REPO_NAME.git"

SCRIPT_FILES="git-line git-line-clean git-line-close git-line-fixup git-line-remove git-line-squash git-line-start git-line-update"

case $1 in
    install)
        echo "Installing git-line to $INSTALL_PATH."

        if [[ -d "$REPO_NAME" ]] && [[ -d "$REPO_NAME/.git" ]]; then
            echo "Using local repository $REPO_NAME."

            REPO_PATH=$REPO_NAME
            remove_repo_after_install=false
        elif [[ -d "../$REPO_NAME" ]] && [[ -d ".git" ]]; then
            echo "Using local current repository."

            REPO_PATH="../$REPO_NAME"
            remove_repo_after_install=false
        else
            echo "Cloning repo from GitHub to $REPO_NAME."

            git clone $REPO_URL

            REPO_PATH=$REPO_NAME
            remove_repo_after_install=true
        fi

        install -v -d -m 0755 "$INSTALL_PATH"

        for file in $SCRIPT_FILES; do
            install -v -m 0755 "$REPO_PATH/scripts/$file" "$INSTALL_PATH"
        done

        if [[ $remove_repo_after_install == true ]]; then
            rm -rf $REPO_PATH
        fi
        ;;

    uninstall)
        echo "Uninstalling git-line from $INSTALL_PATH."

        for file in $SCRIPT_FILES; do
            rm -vf "$INSTALL_PATH/$file"
        done
        ;;
esac