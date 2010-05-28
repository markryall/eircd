-module(ei_sup).

-include_lib("eunit/include/eunit.hrl").

-behaviour(supervisor).

-export([start_link/1, start_child/0]).
-export([init/1]).

-define(SERVER, ?MODULE).

start_link(LSock) ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, [LSock]).

start_child() ->
    supervisor:start_child(?SERVER, []).

init([LSock]) ->
    RestartStrategy = simple_one_for_one,
    MaxRestarts = 0,
    MaxSecondsBetweenRestarts = 1,

    SupFlags = {RestartStrategy, MaxRestarts, MaxSecondsBetweenRestarts},

    Restart = temporary,
    Shutdown = brutal_kill,
    Type = worker,

    Server = {ei_server, {ei_server, start_link, [LSock]},
	      Restart, Shutdown, Type, [ei_server]},

    Event = {ei_event, {ei_event, start_link, []},
	     Restart, Shutdown, Type, [ei_event]},

    {ok, {SupFlags, [Server, Event]}}.
