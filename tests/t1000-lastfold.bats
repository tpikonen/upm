
setup() {
    source ./upm
}

# Test a function with input piped from a file and with record name in 3rd arg.
test_pipefun()
{
    cat "$1" | "$2" "$3"
}

# get_password
@test "get_password lastfold-1line" {
    run test_pipefun tests/data/lastfold-1line.vault get_password test
    [ "$status" = 3 ]
    [ -z "$output" ]
}

@test "get_password lastfold-2line" {
    run test_pipefun tests/data/lastfold-2line.vault get_password test
    [ "$status" = 1 ]
    [ "$output" = "pass" ]
}

@test "get_password lastfold-3line" {
    run test_pipefun tests/data/lastfold-3line.vault get_password test
    [ "$status" = 0 ]
    [ "$output" = "pass" ]
}

@test "get_password lastfold-4line" {
    run test_pipefun tests/data/lastfold-4line.vault get_password test
    [ "$status" = 2 ]
    [ "$output" = "pass" ]
}

# get_user
@test "get_user lastfold-1line" {
    run test_pipefun tests/data/lastfold-1line.vault get_user test
    [ "$status" = 3 ]
    [ -z "$output" ]
}

@test "get_user lastfold-2line" {
    run test_pipefun tests/data/lastfold-2line.vault get_user test
    [ "$status" = 1 ]
    [ -z "$output" ]
}

@test "get_user lastfold-3line" {
    run test_pipefun tests/data/lastfold-3line.vault get_user test
    [ "$status" = 0 ]
    [ "$output" = "user" ]
}

@test "get_user lastfold-4line" {
    run test_pipefun tests/data/lastfold-4line.vault get_user test
    [ "$status" = 2 ]
    [ "$output" = "user" ]
}

# get_both
@test "get_both lastfold-1line" {
    run test_pipefun tests/data/lastfold-1line.vault get_both test
    [ "$status" = 3 ]
    [ -z "$output" ]
}

@test "get_both lastfold-2line" {
    run test_pipefun tests/data/lastfold-2line.vault get_both test
    [ "$status" = 1 ]
    [ "$output" = "$(printf '\npass')" ]
}

@test "get_both lastfold-3line" {
    run test_pipefun tests/data/lastfold-3line.vault get_both test
    [ "$status" = 0 ]
    [ "$output" = "$(printf 'user\npass')" ]
}

@test "get_both lastfold-4line" {
    run test_pipefun tests/data/lastfold-4line.vault get_both test
    [ "$status" = 2 ]
    [ "$output" = "$(printf 'user\npass')" ]
}

# empty key
@test "get_password empty key" {
    run test_pipefun tests/data/lastfold-3line.vault get_password
    [ "$status" = 4 ]
    [ -z "$output" ]
}

@test "get_user empty key" {
    run test_pipefun tests/data/lastfold-3line.vault get_user
    [ "$status" = 4 ]
    [ -z "$output" ]
}

@test "get_both empty key" {
    run test_pipefun tests/data/lastfold-3line.vault get_both
    [ "$status" = 4 ]
    [ -z "$output" ]
}

# bad key
@test "get_password bad key" {
    run test_pipefun tests/data/lastfold-3line.vault get_password foo
    [ "$status" = 4 ]
    [ -z "$output" ]
}

@test "get_user bad key" {
    run test_pipefun tests/data/lastfold-3line.vault get_user foo
    [ "$status" = 4 ]
    [ -z "$output" ]
}

@test "get_both bad key" {
    run test_pipefun tests/data/lastfold-3line.vault get_both foo
    [ "$status" = 4 ]
    [ -z "$output" ]
}
