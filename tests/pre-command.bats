#!/usr/bin/env bats

load "$BATS_PLUGIN_PATH/load.bash"

setup() {
  export TMP_DIR=$(mktemp -d)
}

teardown() {
  rm -rf "${TMP_DIR}"
  unset TMP_DIR
}

@test "Command fails if LT_USERNAME is not set" {
  export LT_USERNAME=""
  export LT_ACCESS_KEY=""

  run "${PWD}/hooks/pre-command"

  assert_failure
  assert_output --partial "LT_USERNAME not set"

  unset LT_USERNAME
  unset LT_ACCESS_KEY
}

@test "Command fails if LT_ACCESS_KEY is not set" {
  export LT_USERNAME="my-username"
  export LT_ACCESS_KEY=""
  
  run "${PWD}/hooks/pre-command"

  assert_failure
  assert_output --partial "LT_ACCESS_KEY not set"

  unset LT_USERNAME
  unset LT_ACCESS_KEY
}

@test "Command fails if BUILDKITE_JOB_ID is not set when invoked without a tunnel name" {
  export LT_USERNAME="username"
  export LT_ACCESS_KEY="access-key"

  run "${PWD}/hooks/pre-command"

  assert_failure
  assert_output --partial "BUILDKITE_JOB_ID not set"

  unset LT_USERNAME
  unset LT_ACCESS_KEY
}


@test "Command fails for unknown OS" {
  export LT_USERNAME="username"
  export LT_ACCESS_KEY="access-key"
  export BUILDKITE_JOB_ID="job-id"
  local ORIGINAL_OSTYPE="${OSTYPE}"
  export OSTYPE="os-arch"

  
  run "${PWD}/hooks/pre-command"

  assert_failure
  assert_output --partial "Unknown OS: ${OSTYPE}"

  unset LT_USERNAME
  unset LT_ACCESS_KEY
  unset BUILDKITE_JOB_ID
  export OSTYPE="${ORIGINAL_OSTYPE}"
}




