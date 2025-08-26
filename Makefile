TESTS_INIT=tests/minimal_init.lua
TESTS_DIR=tests

.PHONY: format lint test

check: format lint test

format:
	stylua .

lint:
	@luacheck .

test:
	@nvim \
		--headless \
		--noplugin \
		-u ${TESTS_INIT} \
		-c "PlenaryBustedDirectory ${TESTS_DIR} { minimal_init = '${TESTS_INIT}' }"
