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
        read -p "Please enter the protected branches separated with a space (leave blank to use 'main master develop'): " -r

        if [[ -z $REPLY ]]; then
            PROTECTED_BRANCHES="main master develop"
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

GIT_LINE_COLOR_GREEN=2
GIT_LINE_COLOR_YELLOW=3
GIT_LINE_COLOR_BLUE=4

function git_line_terminal_supports_style() {
    if [[ -n ${NO_COLOR:-} ]] || [[ ! -t 1 ]] || [[ -z ${TERM:-} ]]; then
        return 1
    fi

    return 0
}

function git_line_style() {
    if ! git_line_terminal_supports_style; then
        return 0
    fi

    tput "$@" 2>/dev/null || true
}

function git_line_color_style() {
    local color=$1

    git_line_style setaf "$color"
}

function git_line_info_style() {
    git_line_color_style "$GIT_LINE_COLOR_BLUE"
}

function git_line_success_style() {
    git_line_color_style "$GIT_LINE_COLOR_GREEN"
}

function git_line_warning_style() {
    git_line_color_style "$GIT_LINE_COLOR_YELLOW"
}

function git_line_bold_style() {
    git_line_style bold
}

function git_line_reset_style() {
    git_line_style sgr0
}

function git_line_print_info() {
    local info_style
    local reset_style

    info_style=$(git_line_info_style)
    reset_style=$(git_line_reset_style)

    printf '%s%s%s\n\n' "$info_style" "$*" "$reset_style"
}

function git_line_sanitize_branch_name() {
    printf '%s\n' "$1" | tr ' /' '--'
}

function git_line_encoded_base_branch_from_branch() {
    local current_branch=$1

    if [[ $current_branch =~ (^|/)from-([^/]+)/ ]]; then
        printf '%s\n' "${BASH_REMATCH[2]}"
        return 0
    fi

    return 1
}

function git_line_resolve_local_branch_from_encoded_name() {
    local encoded_branch_name=$1
    local branch
    local matched_branch
    local matched_count

    matched_branch=""
    matched_count=0

    while IFS= read -r branch; do
        if [[ $(git_line_sanitize_branch_name "$branch") == "$encoded_branch_name" ]]; then
            matched_branch=$branch
            matched_count=$((matched_count + 1))
        fi
    done < <(git for-each-ref --format='%(refname:short)' refs/heads/ 2>/dev/null)

    if [[ $matched_count -eq 1 ]]; then
        printf '%s\n' "$matched_branch"
        return 0
    fi

    return 1
}

function git_line_current_branch_base() {
    local current_branch=$1
    local encoded_base_branch

    encoded_base_branch=$(git_line_encoded_base_branch_from_branch "$current_branch") || return 1
    git_line_resolve_local_branch_from_encoded_name "$encoded_base_branch"
}

function git_line_remote_tracking_branch_for_branch() {
    local branch=$1
    local upstream_branch

    if upstream_branch=$(git rev-parse --abbrev-ref --symbolic-full-name "$branch@{upstream}" 2>/dev/null); then
        printf '%s\n' "$upstream_branch"
        return 0
    fi

    if git show-ref --verify --quiet "refs/remotes/origin/$branch"; then
        printf 'origin/%s\n' "$branch"
        return 0
    fi

    return 1
}

function git_line_upstream_remote_for_branch() {
    local branch=$1
    local remote

    remote=$(git config "branch.$branch.remote")

    if [[ -n $remote ]] && [[ $remote != "." ]]; then
        printf '%s\n' "$remote"
        return 0
    fi

    return 1
}

function git_line_upstream_merge_ref_for_branch() {
    local branch=$1
    local merge_ref

    merge_ref=$(git config "branch.$branch.merge")

    if [[ -n $merge_ref ]]; then
        printf '%s\n' "$merge_ref"
        return 0
    fi

    return 1
}

function git_line_ref_has_commits_not_in_head() {
    local ref=$1
    local commit_count

    commit_count=$(git rev-list --count "HEAD..$ref" 2>/dev/null) || return 1

    [[ $commit_count -gt 0 ]]
}

function git_line_base_branch_has_updates() {
    local base_branch=$1
    local remote_tracking_branch

    if git_line_ref_has_commits_not_in_head "$base_branch"; then
        return 0
    fi

    remote_tracking_branch=$(git_line_remote_tracking_branch_for_branch "$base_branch") || return 1

    if [[ $remote_tracking_branch == "$base_branch" ]]; then
        return 1
    fi

    git_line_ref_has_commits_not_in_head "$remote_tracking_branch"
}

function git_line_show_insights() {
    local current_branch
    local base_branch

    current_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null) || return 0
    base_branch=$(git_line_current_branch_base "$current_branch") || return 0

    if git_line_base_branch_has_updates "$base_branch"; then
        git_line_print_info "Base branch \"$base_branch\" has new commits. Run \`git line update\` to rebase the current branch."
    fi
}

function git_line_fetch_branch_from_upstream_if_available() {
    local branch=$1
    local merge_ref
    local remote

    if remote=$(git_line_upstream_remote_for_branch "$branch") &&
        merge_ref=$(git_line_upstream_merge_ref_for_branch "$branch"); then
        git fetch "$remote" "$merge_ref:refs/heads/$branch"
        return
    fi

    if git show-ref --verify --quiet "refs/remotes/origin/$branch" ||
        git ls-remote --exit-code --heads origin "$branch" >/dev/null 2>&1; then
        git fetch origin "refs/heads/$branch:refs/heads/$branch"
    fi
}
