TESTS = $(sort $(wildcard tests/t[0-9][0-9][0-9][0-9]-*.bats))

test-pre-clean:
	#rm -rf tests/test-results "tests/trash directory"*

test:
	bats $(TESTS)

# Force tests to get run every time
.PHONY: test test-pre-clean $(TESTS)

