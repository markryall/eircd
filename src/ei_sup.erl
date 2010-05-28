-module(ei_sup).

-include_lib("eunit/include/eunit.hrl").

-behaviour(supervisor).

-export([start_link/1]).
-export([init/1]).

-define(SERVER, ?MODULE).

start_link(LSock) ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, [LSock]).

init([LSock]) ->
    ServerSup = {ei_server_sup, {ei_server_sup, start_link, [LSock]},
	      permanent, 2000, supervisor, [ei_server]},

    EventManager = {ei_event, {ei_event, start_link, []},
	     permanent, 2000, worker, [ei_event]},

    Children = [EventManager, ServerSup],

    RestartStrategy = {one_for_one, 4, 3600},

    {ok, {RestartStrategy, Children}}.
