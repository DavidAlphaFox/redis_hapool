%%%-------------------------------------------------------------------
%%% @author thi
%%% @copyright (C) 2015, yunba.io
%%% @doc
%%%
%%% @end
%%% Created : 22. 四月 2015 下午7:30
%%%-------------------------------------------------------------------
-module(redis_hapool_sup).
-author("thi").

-behaviour(supervisor).

%% API
-export([start_link/1]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%%===================================================================
%%% API functions
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% Starts the supervisor
%%
%% @end
%%--------------------------------------------------------------------
-spec(start_link(list()) ->
    {ok, Pid :: pid()} | ignore | {error, Reason :: term()}).
start_link([RedisPools]) ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, [RedisPools]).

%%%===================================================================
%%% Supervisor callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Whenever a supervisor is started using supervisor:start_link/[2,3],
%% this function is called by the new process to find out about
%% restart strategy, maximum restart frequency and child
%% specifications.
%%
%% @end
%%--------------------------------------------------------------------
-spec(init(Args :: term()) ->
    {ok, {SupFlags :: {RestartStrategy :: supervisor:strategy(),
        MaxR :: non_neg_integer(), MaxT :: non_neg_integer()},
        [ChildSpec :: supervisor:child_spec()]
    }} |
    ignore |
    {error, Reason :: term()}).
init([RedisPools]) ->
    RestartStrategy = one_for_one,
    MaxRestarts = 1000,
    MaxSecondsBetweenRestarts = 3600,

    SupFlags = {RestartStrategy, MaxRestarts, MaxSecondsBetweenRestarts},

    Restart = permanent,
    Shutdown = 2000,
    Type = worker,

    PoolSpecs = lists:map(
        fun({PoolName, Size, MaxOverflow, Addresses}) ->
            Pool = lists:foldl(
                fun({Host, Port}, Acc) ->
                    [{list_to_atom(atom_to_list(PoolName) ++ "_" ++ integer_to_list(length(Acc))), Size, MaxOverflow, Host, Port} | Acc]
                end, [], Addresses),
            {PoolName, {'redis_hapool_server', start_link, [PoolName, lists:reverse(Pool)]},
                Restart, Shutdown, Type, ['redis_hapool_server']}
        end, RedisPools),

    {ok, {SupFlags, PoolSpecs}}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
