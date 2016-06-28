-module(redis_hapool_app).

-behaviour(application).

-include_lib("elog/include/elog.hrl").

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    RedisPool = case application:get_env(redis_pools) of
                    undefined ->
                        [{defaultpool, 10, 10, [{"localhost", 6379}]}];
                    {ok, ConfigRedisPool} when is_list(ConfigRedisPool)->
                        ConfigRedisPool
                end,
    ?INFO("get redis_pools config [~p]", [RedisPool]),

    redis_hapool_sup:start_link([RedisPool]).

stop(_State) ->
    ok.
