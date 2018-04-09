
setup() {
    source ./upm
}

# Test a function with input piped from a file.
test_pipefun()
{
    cat "$1" | "$2"
}

# get_password
@test "get_password lastfold-1line" {
    run test_pipefun tests/data/lastfold-1line.vault get_password
    [ "$status" = 3 ]
    [ -z "$output" ]
}

@test "get_password lastfold-2line" {
    run test_pipefun tests/data/lastfold-2line.vault get_password
    [ "$status" = 1 ]
    [ "$output" = "pass" ]
}

@test "get_password lastfold-3line" {
    run test_pipefun tests/data/lastfold-3line.vault get_password
    [ "$status" = 0 ]
    [ "$output" = "pass" ]
}

@test "get_password lastfold-4line" {
    run test_pipefun tests/data/lastfold-4line.vault get_password
    [ "$status" = 2 ]
    [ "$output" = "pass" ]
}

# get_user
@test "get_user lastfold-1line" {
    run test_pipefun tests/data/lastfold-1line.vault get_user
    [ "$status" = 3 ]
    [ -z "$output" ]
}

@test "get_user lastfold-2line" {
    run test_pipefun tests/data/lastfold-2line.vault get_user
    [ "$status" = 1 ]
    [ -z "$output" ]
}

@test "get_user lastfold-3line" {
    run test_pipefun tests/data/lastfold-3line.vault get_user
    [ "$status" = 0 ]
    [ "$output" = "user" ]
}

@test "get_user lastfold-4line" {
    run test_pipefun tests/data/lastfold-4line.vault get_user
    [ "$status" = 2 ]
    [ "$output" = "user" ]
}

# get_both
@test "get_both lastfold-1line" {
    run test_pipefun tests/data/lastfold-1line.vault get_both
    [ "$status" = 3 ]
    [ -z "$output" ]
}

@test "get_both lastfold-2line" {
    run test_pipefun tests/data/lastfold-2line.vault get_both
    [ "$status" = 1 ]
    [ "$output" = "$(printf '\npass')" ]
}

@test "get_both lastfold-3line" {
    run test_pipefun tests/data/lastfold-3line.vault get_both
    [ "$status" = 0 ]
    [ "$output" = "$(printf 'user\npass')" ]
}

@test "get_both lastfold-4line" {
    run test_pipefun tests/data/lastfold-4line.vault get_both
    [ "$status" = 2 ]
    [ "$output" = "$(printf 'user\npass')" ]
}
