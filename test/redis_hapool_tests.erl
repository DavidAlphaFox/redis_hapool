%%%-------------------------------------------------------------------
%%% @author zhanghu
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 三月 2016 下午5:32
%%%-------------------------------------------------------------------
-module(redis_hapool_tests).
-author("zhanghu").

-include_lib("eunit/include/eunit.hrl").

main_test() ->
    {time, 20, simple_test_}.

simple_test_() ->
    {ok, R1} = redis:start_link(server, [ { <<"port">>, <<"19000">> } ]),
    {ok, R2} = redis:start_link(server, [ { <<"port">>, <<"19001">> } ]),
    {ok, R3} = redis:start_link(server, [ { <<"port">>, <<"19002">> } ]),
    timer:sleep(4000),
    {ok, C1} = eredis:start_link("127.0.0.1", 19000),
    {ok, C2} = eredis:start_link("127.0.0.1", 19001),
    {ok, C3} = eredis:start_link("127.0.0.1", 19002),
    eredis:q(C1, ["SET", "test", "test1"]),
    eredis:q(C2, ["SET", "test", "test2"]),
    eredis:q(C3, ["SET", "test", "test3"]),

    net_kernel:start([hapool, shortnames]), %% set node name
    erlang:set_cookie(node(), testcookie),
    eredis_pool:start(),
    resource_discovery:start(),
    mnesia:start(),
    redis_hapool:start(),

    io:format("19000 should work well"),
    {ok, <<"test1">>} = redis_hapool:q(["GET", "test"]),

    io:format("Failover to 19001"),
    redis:stop(server, R1),
    timer:sleep(3000),
    {ok, <<"test2">>} = redis_hapool:q(["GET", "test"]),

    io:format("Failover to 19002"),
    redis:stop(server, R2),
    timer:sleep(3000),
    {ok, <<"test3">>} = redis_hapool:q(["GET", "test"]),

    io:format("No connection"),
    redis:stop(server, R3),
    timer:sleep(3000),
    {error, no_connection} = redis_hapool:q(["GET", "test"]),

    io:format("Recovery 19000"),
    {ok, R1_2} = redis:start_link(server, [ { <<"port">>, <<"19000">> } ]),
    timer:sleep(3000),
    {ok, C1_2} = eredis:start_link("127.0.0.1", 19000),
    eredis:q(C1_2, ["SET", "test", "test1_2"]),

    {ok, <<"test1_2">>} = redis_hapool:q(["GET", "test"]),

    redis:stop(server, R1_2),
    [].

