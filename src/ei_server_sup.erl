-module(ei_server_sup).

-behaviour(supervisor).

-export([start_link/1,
	 start_child/0
	 ]).

-export([init/1]).

-include_lib("ei_logging.hrl").

-define(SERVER, ?MODULE).

start_link(LSock) ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, [LSock]).

start_child() ->
    supervisor:start_child(?SERVER, []).

init([LSock]) ->
    ?LOG("init"),
    ServerSpec = {ei_server, {ei_server, start_link, [LSock]},
	       temporary, brutal_kill, worker, [ei_server]},
    Children = [ServerSpec],
    RestartStrategy = {simple_one_for_one, 0, 1},
    {ok, {RestartStrategy, Children}}.
