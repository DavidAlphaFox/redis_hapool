%%%-------------------------------------------------------------------
%%% @author zhanghu
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. 三月 2016 下午3:09
%%%-------------------------------------------------------------------
-author("zhanghu").

-define(REDISES_INFO_TABLE, redis_pool_info_table).
-define(REDISES_INFO_TABLE_ID, 1).
-record(?REDISES_INFO_TABLE, {
    info_id         ::integer(),
    infos           ::list()            %% list of redis configuration
}).
-define(REDISES_CONNECTION_TABLE, redises_connection_table).
-define(REDISES_CONNECTION_LIST, redises_connection_list).

-type redis_status() :: init | read_write | read_only | write_only | fail.

%-record(redis_info, {name::atom(), size::list(), connection::list()}).

-type redis_info() :: term().

-type redis_info_list() :: list(redis_info()).

-record(redis_connection, {
    info                ::redis_info(),
    status              ::redis_status()
}).

-type redis_connection_list() :: list(#redis_connection{}).
