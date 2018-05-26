#!/usr/bin/env bash

function setup_configuration() {
    DEVELOPMENT_BRANCH=$(git config git-line.development-branch)

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

    PROTECTED_BRANCHES=$(git config git-line.protected-branches)

    if [[ -z $PROTECTED_BRANCHES ]]; then
        echo "Protected branches are not set for the current repository."
        read -p "Please enter the protected branches separated with a space (leave blank to use 'master develop'): " -r

        if [[ -z $REPLY ]]; then
            PROTECTED_BRANCHES="master develop"
        else
            PROTECTED_BRANCHES=$REPLY
        fi

        git config git-line.protected-branches "$PROTECTED_BRANCHES"

        echo "Protected branches was set to '$PROTECTED_BRANCHES'."
        echo
    fi

    BRANCH_PREFIX_ENABLED=$(git config git-line.branch-prefix-enabled)
    BRANCH_PREFIX=$(git config git-line.branch-prefix)

    if [[ -z $BRANCH_PREFIX_ENABLED ]]; then
        echo "Branch prefix is not set for the current repository."
        read -p "Please enter a prefix for branches created with \`git line start\` (leave blank for none): " -r

        if [[ -z $REPLY ]]; then
            BRANCH_PREFIX_ENABLED="false"
            BRANCH_PREFIX=""
        else
            BRANCH_PREFIX_ENABLED="true"
            BRANCH_PREFIX=$REPLY
        fi

        git config git-line.branch-prefix-enabled "$BRANCH_PREFIX_ENABLED"
        git config git-line.branch-prefix "$BRANCH_PREFIX"

        if [[ "$BRANCH_PREFIX_ENABLED" == "true" ]]; then
            echo "Branch prefix was set to '$BRANCH_PREFIX'."
            echo
        else
            echo "Branch prefix was disabled."
            echo
        fi
    fi
}
