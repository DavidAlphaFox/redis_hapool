REBAR := ./rebar -j8

.PHONY: all deps doc test clean release

all: compile

compile: deps
	$(REBAR) compile

deps:
	$(REBAR) get-deps

doc:
	$(REBAR) doc skip_deps=true

clean:
	$(REBAR) clean

relclean:
	rm -rf rel/redis_hapool

generate: compile
	cd rel && ../$(REBAR) generate

run: generate
	./rel/redis_hapool/bin/redis_hapool start

console: generate
	./rel/redis_hapool/bin/redis_hapool console

foreground: generate
	./rel/redis_hapool/bin/redis_hapool foreground

erl: compile
	erl -pa ebin/ -pa deps/*/ebin/ -s redis_hapool

