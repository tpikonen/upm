#!/usr/bin/env bats

# Whole program tests with base.vault

setup() {
    export UPM_NO_CRYPT=1
    export UPMFILE=./tests/data/base.vault
    export UPM=./upm
}

teardown() {
    unset -v UPM_NO_CRYPT
    unset -v UPMFILE
}

function no_stderr {
     "$@" 2>/dev/null
}

function no_stdout {
     "$@" >/dev/null
}

@test "upm ls" {
    run ${UPM} -o ls
    [ "$status" -eq 0 ]
    [ "$output" = "$(printf 'test\nanother\nthird')" ]
}

@test "upm pass first" {
    run ${UPM} -o pass test
    [ "$status" -eq 0 ]
    [ "$output" = "pass" ]
}

@test "upm user first" {
    run ${UPM} -o user test
    [ "$status" -eq 0 ]
    [ "$output" = "user" ]
}

@test "upm both first" {
    run ${UPM} -o both test
    echo "$output"
    [ "$status" -eq 0 ]
    [ "$output" = "$(printf 'user\npass')" ]
}

@test "upm pass 2-line" {
    run ${UPM} -o pass another
    [ "$status" -eq 0 ]
    [ "$output" = "pass2" ]
}

@test "upm user 2-line stdout" {
    run no_stderr ${UPM} -o user another
    [ "$status" -eq 5 ]
    [ -z "$output" ]
}

@test "upm user 2-line stderr" {
    run no_stdout ${UPM} -o user another
    [ "$status" -eq 5 ]
    [ "$output" = "No username found for key 'another'" ]
}

@test "upm both 2-line stdout" {
    run no_stderr ${UPM} -o both another
    [ "$status" -eq 0 ]
    [ "$output" = "$(printf '\npass2')" ]
}

@test "upm both 2-line stderr" {
    run no_stdout ${UPM} -o both another
    echo "$output"
    [ "$status" -eq 0 ]
    [ "$output" = "$(printf '\nEmpty username found for key '\''another'\')" ]
}

@test "upm pass last " {
    run ${UPM} -o pass third
    [ "$status" -eq 0 ]
    [ "$output" = "s3kr1T" ]
}

@test "upm user last" {
    run ${UPM} -o user third
    [ "$status" -eq 0 ]
    [ "$output" = "john" ]
}

@test "upm both last" {
    run ${UPM} -o both third
    echo "$output"
    [ "$status" -eq 0 ]
    [ "$output" = "$(printf 'john\ns3kr1T')" ]
}

@test "upm pass badkey" {
    run ${UPM} -o pass foo
    echo "$output"
    [ "$status" -eq 5 ]
    [ "$output" = "key 'foo' not found" ]
}

@test "upm user badkey" {
    run ${UPM} -o user foo
    [ "$status" -eq 5 ]
    [ "$output" = "key 'foo' not found" ]
}

@test "upm both badkey" {
    run ${UPM} -o both foo
    echo "$output"
    [ "$status" -eq 5 ]
    [ "$output" = "key 'foo' not found" ]
}

