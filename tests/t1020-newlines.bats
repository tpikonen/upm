
setup() {
    source ./upm
}

# Test a function with input piped from a file and with record name in 3rd arg.
test_pipefun()
{
    cat "$1" | "$2" "$3"
}

# good key
@test "get_password newlines ok key" {
    run test_pipefun tests/data/newlines.vault get_password test
    [ "$status" = 0 ]
    [ "$output" = "pass" ]
}

@test "get_user newlines ok key" {
    run test_pipefun tests/data/newlines.vault get_user test
    [ "$status" = 0 ]
    [ "$output" = "user" ]
}

@test "get_both newlines ok key" {
    run test_pipefun tests/data/newlines.vault get_both test
    [ "$status" = 0 ]
    [ "$output" = "$(printf 'user\npass')" ]
}

# empty key
@test "get_password newlines empty key" {
    run test_pipefun tests/data/newlines.vault get_password
    [ "$status" = 4 ]
    [ -z "$output" ]
}

@test "get_user newlines empty key" {
    run test_pipefun tests/data/newlines.vault get_user
    [ "$status" = 4 ]
    [ -z "$output" ]
}

@test "get_both newlines empty key" {
    run test_pipefun tests/data/newlines.vault get_both
    [ "$status" = 4 ]
    [ -z "$output" ]
}

# bad key
@test "get_password newlines bad key" {
    run test_pipefun tests/data/newlines.vault get_password foo
    [ "$status" = 4 ]
    [ -z "$output" ]
}

@test "get_user newlines bad key" {
    run test_pipefun tests/data/newlines.vault get_user foo
    [ "$status" = 4 ]
    [ -z "$output" ]
}

@test "get_both newlines bad key" {
    run test_pipefun tests/data/newlines.vault get_both foo
    [ "$status" = 4 ]
    [ -z "$output" ]
}
