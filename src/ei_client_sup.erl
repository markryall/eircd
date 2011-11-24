-module(ei_client_sup).

-behaviour(supervisor).

-export([start_link/1,
	 start_child/0
	 ]).

-export([init/1]).

-include_lib("ei_logging.hrl").

-define(CLIENT, ?MODULE).

start_link(LSock) ->
    supervisor:start_link({local, ?CLIENT}, ?MODULE, [LSock]).

start_child() ->
    supervisor:start_child(?CLIENT, []).

init([LSock]) ->
    ?LOG("init"),
    ClientSpec = {ei_client, {ei_client, start_link, [LSock]},
	       temporary, brutal_kill, worker, [ei_client]},
    Children = [ClientSpec],
    RestartStrategy = {simple_one_for_one, 0, 1},
    {ok, {RestartStrategy, Children}}.
