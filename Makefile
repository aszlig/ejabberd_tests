.PHONY: all test console compile
all: test

TESTSPEC ?= default.spec
TESTSPEC_PUBSUB ?= pubsub.spec
PRESET   ?= all

test_clean: get-deps
	rm -rf tests/*.beam
	make test

cover_test_clean: get-deps
	rm -rf tests/*.beam
	make cover_test

pubsubtest: prepare
	erl -noinput -sname test -setcookie ejabberd \
		-pa `pwd`/tests \
		    `pwd`/ebin \
			`pwd`/deps/*/ebin \
		$(ADD_OPTS) \
		-s run_common_test main test=quick spec=$(TESTSPEC_PUBSUB)

quicktest: prepare
	erl -noinput -sname test -setcookie ejabberd \
		-pa `pwd`/tests \
		    `pwd`/ebin \
			`pwd`/deps/*/ebin \
		$(ADD_OPTS) \
		-s run_common_test main test=quick spec=$(TESTSPEC)

cover_quicktest: prepare
	erl -noinput -sname test -setcookie ejabberd \
		-pa `pwd`/tests \
		    `pwd`/ebin \
			`pwd`/deps/*/ebin \
		$(ADD_OPTS) \
		-s run_common_test main test=quick spec=$(TESTSPEC) cover=true

test_preset: prepare
	erl -noinput -sname test -setcookie ejabberd \
		-pa `pwd`/tests \
		    `pwd`/ebin \
			`pwd`/deps/*/ebin \
		$(ADD_OPTS) \
		-s run_common_test main test=full spec=$(TESTSPEC) preset=$(PRESET)

cover_test_preset: prepare
	erl -noinput -sname test -setcookie ejabberd \
		-pa `pwd`/tests \
		    `pwd`/ebin \
			`pwd`/deps/*/ebin \
		$(ADD_OPTS) \
		-s run_common_test main test=full spec=$(TESTSPEC) preset=$(PRESET) cover=true

test: prepare
	erl -noinput -sname test -setcookie ejabberd \
		-pa `pwd`/tests \
		    `pwd`/ebin \
			`pwd`/deps/*/ebin \
		$(ADD_OPTS) \
		-s run_common_test main test=full spec=$(TESTSPEC)

cover_test: prepare
	erl -noinput -sname test -setcookie ejabberd \
		-pa `pwd`/tests \
		    `pwd`/ebin \
			`pwd`/deps/*/ebin \
		$(ADD_OPTS) \
		-s run_common_test main test=full spec=$(TESTSPEC) cover=true

prepare: compile
	erlc -Ideps/exml/include \
		 run_common_test.erl
	mkdir -p ct_report

console: compile
	erl -sname test -setcookie ejabberd \
		-pa `pwd`/tests \
		    `pwd`/ebin \
			`pwd`/deps/*/ebin \

compile: get-deps
	./rebar compile

get-deps: rebar
	./rebar get-deps

clean: rebar
	rm -rf tests/*.beam
	./rebar clean

rebar:
	wget http://cloud.github.com/downloads/basho/rebar/rebar
	chmod u+x rebar
