# redis_hapool
Redis Cline HA Pool in Erlang

# Configration
```Erlang
      {redis_pool,[
          {pool1, 30, 20, "127.0.0.1", 19000},
          {pool2, 30, 20, "127.0.0.1", 19001},
          {pool3, 30, 20, "127.0.0.1", 19002}
      ]}
```

# Compile
rebar get-deps compile

# Test
rebar eunit skip_deps=true

# Run
erl -pa ebin -pa deps/*/ebin -sname ha -setcookie abc -mnesia dir '"/tmp/mdb"' -s eredis_pool -s redis_hapool

# APIs

## redis_hapool:q(["GET", "test"])
