%%%-------------------------------------------------------------------
%%% @author zhanghu
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. 三月 2016 下午7:56
%%%-------------------------------------------------------------------
-module(redis_hapool).
-author("zhanghu").

-behaviour(application).

%% Application callbacks
-export([start/0, start/2,
    stop/1]).

%% APIs
-export([q/2, q/3]).

%% APIs

-spec q(PoolName :: atom(), Command::iolist()) ->
    {ok, binary() | [binary()]} | {error, Reason::binary()}.
q(PoolName, Command) ->
    redis_hapool_server:q(PoolName, Command).

q(PoolName, Command, Timeout) ->
    redis_hapool_server:q(PoolName, Command, Timeout).

%%%===================================================================
%%% Application callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called whenever an application is started using
%% application:start/[1,2], and should start the processes of the
%% application. If the application is structured according to the OTP
%% design principles as a supervision tree, this means starting the
%% top supervisor of the tree.
%%
%% @end
%%--------------------------------------------------------------------
-spec(start(StartType :: normal | {takeover, node()} | {failover, node()},
    StartArgs :: term()) ->
    {ok, pid()} |
    {ok, pid(), State :: term()} |
    {error, Reason :: term()}).
start(_StartType, _StartArgs) ->
    case 'TopSupervisor':start_link() of
        {ok, Pid} ->
            {ok, Pid};
        Error ->
            Error
    end.

start() -> start(?MODULE).

start(App) ->
    start_ok(App, application:start(App, permanent)).

start_ok(_App, ok) -> ok;
start_ok(_App, {error, {already_started, _App}}) -> ok;
start_ok(App, {error, {not_started, Dep}}) ->
    io:format("start dep[~p]~n", [Dep]),
    ok = start(Dep),
    start(App);
start_ok(App, {error, Reason}) ->
    erlang:error({app_start_failed, App, Reason}).

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called whenever an application has stopped. It
%% is intended to be the opposite of Module:start/2 and should do
%% any necessary cleaning up. The return value is ignored.
%%
%% @end
%%--------------------------------------------------------------------
-spec(stop(State :: term()) -> term()).
stop(_State) ->
    ok.

%%%===================================================================
%%% Internal functions
%%%===================================================================
