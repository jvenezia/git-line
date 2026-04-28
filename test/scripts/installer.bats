#!/usr/bin/env bats

source 'test/test_helper/load_bats_libraries.bash'
source 'test/test_helper/test_helper.bash'

setup() {
    setup_tests
    install_path="$TEST_TMP_DIR/install-bin"
}

teardown() {
    clean_tests
}

script_files=(
    git-line_utils.bash
    git-line
    git-line-edit
    git-line-nuke
    git-line-push
    git-line-remove
    git-line-stash
    git-line-squash
    git-line-start
    git-line-switch
    git-line-unstack
    git-line-update
    git-line-commit
)

@test "'installer' installs scripts to configured INSTALL_PATH" {
    run env INSTALL_PATH="$install_path" bash "$ROOT/installer.bash" install

    assert_equal "$status" 0
    assert_output --partial "Installing git-line to $install_path."
    assert_output --partial "Using local repository $ROOT."

    for file in "${script_files[@]}"; do
        assert [ -x "$install_path/$file" ]
    done

    assert [ -r "$install_path/.git-line-version" ]
}

@test "'installer' reports replaced files" {
    mkdir -p "$install_path"
    echo "local edit" >"$install_path/git-line"

    run env INSTALL_PATH="$install_path" bash "$ROOT/installer.bash" install

    assert_equal "$status" 0
    assert_output --partial "Replacing existing file: $install_path/git-line"
}

@test "'installer' uninstalls configured scripts" {
    env INSTALL_PATH="$install_path" bash "$ROOT/installer.bash" install

    run env INSTALL_PATH="$install_path" bash "$ROOT/installer.bash" uninstall

    assert_equal "$status" 0

    for file in "${script_files[@]}"; do
        assert [ ! -e "$install_path/$file" ]
    done

    assert [ ! -e "$install_path/.git-line-version" ]
}

@test "'installer' displays usage for invalid commands" {
    run bash "$ROOT/installer.bash" invalid

    assert_equal "$status" 1
    assert_output --partial "usage:"
}

@test "'installer' displays usage for too many arguments" {
    run bash "$ROOT/installer.bash" install extra

    assert_equal "$status" 1
    assert_output --partial "usage:"
}
