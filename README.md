# redis_hapool
Redis Client HA Pool in Erlang

# Configration
```Erlang
      {redis_pools,[
          {pool1, 30, 20, [{"127.0.0.1", 19000}]},
          {pool2, 30, 20, [{"127.0.0.1", 19001}]},
          {pool3, 30, 20, [{"127.0.0.1", 19002}]}
      ]}
```

# Compile
rebar get-deps compile

# Test
rebar eunit skip_deps=true

# Run
erl -pa ebin -pa deps/*/ebin -s eredis_pool -s redis_hapool

# APIs

## redis_hapool:q(pool1, ["GET", "test"])
