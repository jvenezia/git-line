#!/usr/bin/env bash
set -euo pipefail

INSTALL_PATH="${INSTALL_PATH:-$HOME/.local/bin}"
REPO_NAME="git-line"
DEFAULT_REPO_URL="https://github.com/jvenezia/$REPO_NAME.git"
REPO_URL="${REPO_URL:-$DEFAULT_REPO_URL}"

SCRIPT_FILES=(
    git-line_utils.bash
    git-line
    git-line-edit
    git-line-nuke
    git-line-push
    git-line-remove
    git-line-squash
    git-line-start
    git-line-switch
    git-line-update
    git-line-commit
)

repo_path=""
temp_repo_parent=""

usage() {
    cat <<EOF
usage: installer.bash <install|uninstall>

Commands:
  install      Install git-line scripts.
  uninstall    Remove git-line scripts.

Environment:
  INSTALL_PATH Install directory. Defaults to \$HOME/.local/bin.
  REPO_URL     Repository URL used when cloning. Defaults to $DEFAULT_REPO_URL.
EOF
}

die() {
    echo "error: $*" >&2
    exit 1
}

cleanup() {
    if [[ -n "$temp_repo_parent" && -d "$temp_repo_parent" ]]; then
        rm -rf -- "$temp_repo_parent"
    fi
}

trap cleanup EXIT

set_repo_path_from_script_location() {
    local script_dir

    script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

    if [[ -d "$script_dir/scripts" ]]; then
        repo_path=$script_dir
        echo "Using local repository $repo_path."
    fi
}

set_repo_path_from_git_root() {
    local git_root

    if ! git_root=$(git rev-parse --show-toplevel 2>/dev/null); then
        return
    fi

    if [[ -d "$git_root/scripts" && -f "$git_root/scripts/git-line" ]]; then
        repo_path=$git_root
        echo "Using local repository $repo_path."
    fi
}

clone_repo() {
    temp_repo_parent=$(mktemp -d "${TMPDIR:-/tmp}/git-line-install.XXXXXX")
    repo_path="$temp_repo_parent/$REPO_NAME"

    echo "Cloning repo from $REPO_URL."
    git clone --depth 1 "$REPO_URL" "$repo_path"
}

resolve_repo_path() {
    set_repo_path_from_script_location

    if [[ -n "$repo_path" ]]; then
        return
    fi

    set_repo_path_from_git_root

    if [[ -n "$repo_path" ]]; then
        return
    fi

    clone_repo
}

install_scripts() {
    local file
    local source_file
    local target_file

    echo "Installing git-line to $INSTALL_PATH."

    resolve_repo_path
    install -d -m 0755 "$INSTALL_PATH"

    for file in "${SCRIPT_FILES[@]}"; do
        source_file="$repo_path/scripts/$file"
        target_file="$INSTALL_PATH/$file"

        [[ -f "$source_file" ]] || die "missing source script: $source_file"

        if [[ -e "$target_file" ]]; then
            if cmp -s "$source_file" "$target_file"; then
                echo "Already up to date: $target_file"
            else
                echo "Replacing existing file: $target_file"
            fi
        else
            echo "Installing new file: $target_file"
        fi

        install -m 0755 "$source_file" "$target_file"
    done
}

uninstall_scripts() {
    local file
    local target_file

    echo "Uninstalling git-line from $INSTALL_PATH."

    for file in "${SCRIPT_FILES[@]}"; do
        target_file="$INSTALL_PATH/$file"

        if [[ -e "$target_file" ]]; then
            rm -v -- "$target_file"
        else
            echo "Not installed: $target_file"
        fi
    done
}

main() {
    local command="${1:-}"

    if [[ $# -gt 1 ]]; then
        usage >&2
        exit 1
    fi

    case "$command" in
        install)
            install_scripts
            ;;
        uninstall)
            uninstall_scripts
            ;;
        -h|--help|help)
            usage
            ;;
        *)
            usage >&2
            exit 1
            ;;
    esac
}

main "$@"
