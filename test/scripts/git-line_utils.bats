#!/usr/bin/env bats

source 'test/test_helper/load_bats_libraries.bash'
source 'test/test_helper/test_helper.bash'

setup() {
    setup_tests
}

teardown() {
    clean_tests
}

capture_success_style() {
    local -x TERM=xterm

    git_line_success_style
}

@test "'git_line_success_style' returns color when captured for terminal output" {
    source "$ROOT/scripts/git-line_utils.bash"

    GIT_LINE_STDOUT_IS_TERMINAL=true

    style=$(capture_success_style)

    assert_equal "${style:0:1}" $'\033'
}

@test "'git_line_success_style' returns empty output when stdout is not a terminal" {
    source "$ROOT/scripts/git-line_utils.bash"

    GIT_LINE_STDOUT_IS_TERMINAL=false

    style=$(capture_success_style)

    assert_equal "$style" ""
}

@test "'git_line_success_style' returns empty output when TERM is empty" {
    source "$ROOT/scripts/git-line_utils.bash"

    GIT_LINE_STDOUT_IS_TERMINAL=true
    TERM=""

    style=$(git_line_success_style)

    assert_equal "$style" ""
}
