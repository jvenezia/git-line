#!/usr/bin/env bash

BATS_LIBRARY_PATH="${BATS_LIB_PATH:-test/test_helper}"

source "$BATS_LIBRARY_PATH/bats-support/load.bash"
source "$BATS_LIBRARY_PATH/bats-assert/load.bash"
