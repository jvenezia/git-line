#!/usr/bin/env bash

if [[ -r "$HOME/.git-extensions.conf" ]]; then
    source "$HOME/.git-extensions.conf"
fi

git_root=$(git rev-parse --show-toplevel)

if [[ -r "$git_root/.git-extensions.conf" ]]; then
    source "$git_root/.git-extensions.conf"
fi

if [[ -z $PROTECTED_BRANCHES ]] || [[ -z $MAIN_BRANCH ]] || [[ -z $DEVELOPMENT_BRANCH ]]; then
    die 'Please create a .git-extensions.conf file in your git root directory and specify PROTECTED_BRANCHES, MAIN_BRANCH and DEVELOPMENT_BRANCH.'
fi
