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
start_link([RedisPool]) ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, [RedisPool]).

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
init([RedisPool]) ->
    RestartStrategy = one_for_one,
    MaxRestarts = 1000,
    MaxSecondsBetweenRestarts = 3600,

    SupFlags = {RestartStrategy, MaxRestarts, MaxSecondsBetweenRestarts},

    Restart = permanent,
    Shutdown = 2000,
    Type = worker,

    AChild = {'redis_hapool_server', {'redis_hapool_server', start_link, [RedisPool]},
        Restart, Shutdown, Type, ['redis_hapool_server']},

    {ok, {SupFlags, [AChild]}}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
