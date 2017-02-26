#!/usr/bin/env bash

function setup_configuration() {
    DEVELOPMENT_BRANCH=$(git config git-line.development-branch)
    PROTECTED_BRANCHES=$(git config git-line.protected-branches)

    if [[ -z $DEVELOPMENT_BRANCH ]]; then
        echo "Development branch is not set for the current repository."
        read -p "Please enter the development branch (leave blank to use 'develop'): " -r

        if [[ -z $REPLY ]]; then
            DEVELOPMENT_BRANCH="develop"
        else
            DEVELOPMENT_BRANCH=$REPLY
        fi

        git config git-line.development-branch "$DEVELOPMENT_BRANCH"

        echo "Development branch was set to '$DEVELOPMENT_BRANCH'."
        echo
    fi

    if [[ -z $PROTECTED_BRANCHES ]]; then
        echo "Protected branches are not set for the current repository."
        read -p "Please the protected branches separated with a space (leave blank to use 'master develop'): " -r

        if [[ -z $REPLY ]]; then
            PROTECTED_BRANCHES="master develop"
        else
            PROTECTED_BRANCHES=$REPLY
        fi

        git config git-line.protected-branches "$PROTECTED_BRANCHES"

        echo "Protected branches was set to '$PROTECTED_BRANCHES'."
        echo
    fi
}