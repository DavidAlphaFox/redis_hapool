# redis_hapool
Redis Cline HA Pool in Erlang

# Compile
rebar get-deps compile

# Test
rebar eunit skip_deps=true

# Run
erl -pa ebin -pa deps/*/ebin -sname ha -setcookie abc -mnesia dir '"/tmp/mdb"' -s eredis_pool -s resource_discovery -s mnesia -s redis_hapool
