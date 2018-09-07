
setup() {
    source ./upm
}

# Test a function with input piped from a file and with record name in 3rd arg.
test_pipefun()
{
    cat "$1" | "$2" "$3"
}

# get_password
@test "get_password onefold-1line" {
    run test_pipefun tests/data/onefold-1line.vault get_password test
    [ "$status" = 3 ]
    [ -z "$output" ]
}

@test "get_password onefold-2line" {
    run test_pipefun tests/data/onefold-2line.vault get_password test
    [ "$status" = 1 ]
    [ "$output" = "pass" ]
}

@test "get_password onefold-3line" {
    run test_pipefun tests/data/onefold-3line.vault get_password test
    [ "$status" = 0 ]
    [ "$output" = "pass" ]
}

@test "get_password onefold-4line" {
    run test_pipefun tests/data/onefold-4line.vault get_password test
    [ "$status" = 2 ]
    [ "$output" = "pass" ]
}

# get_user
@test "get_user onefold-1line" {
    run test_pipefun tests/data/onefold-1line.vault get_user test
    [ "$status" = 3 ]
    [ -z "$output" ]
}

@test "get_user onefold-2line" {
    run test_pipefun tests/data/onefold-2line.vault get_user test
    [ "$status" = 1 ]
    [ -z "$output" ]
}

@test "get_user onefold-3line" {
    run test_pipefun tests/data/onefold-3line.vault get_user test
    [ "$status" = 0 ]
    [ "$output" = "user" ]
}

@test "get_user onefold-4line" {
    run test_pipefun tests/data/onefold-4line.vault get_user test
    [ "$status" = 2 ]
    [ "$output" = "user" ]
}

# get_both
@test "get_both onefold-1line" {
    run test_pipefun tests/data/onefold-1line.vault get_both test
    [ "$status" = 3 ]
    [ -z "$output" ]
}

@test "get_both onefold-2line" {
    run test_pipefun tests/data/onefold-2line.vault get_both test
    [ "$status" = 1 ]
    [ "$output" = "$(printf '\npass')" ]
}

@test "get_both onefold-3line" {
    run test_pipefun tests/data/onefold-3line.vault get_both test
    [ "$status" = 0 ]
    [ "$output" = "$(printf 'user\npass')" ]
}

@test "get_both onefold-4line" {
    run test_pipefun tests/data/onefold-4line.vault get_both test
    [ "$status" = 2 ]
    [ "$output" = "$(printf 'user\npass')" ]
}
