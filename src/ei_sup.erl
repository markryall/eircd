-module(ei_sup).

-behaviour(supervisor).

-export([start_link/1]).
-export([init/1]).

-define(SERVER, ?MODULE).

start_link(LSock) ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, [LSock]).

init([LSock]) ->
    ClientSup = {ei_client_sup, {ei_client_sup, start_link, [LSock]},
	      permanent, 2000, supervisor, [ei_client]},

    Children = [ClientSup],

    RestartStrategy = {one_for_one, 4, 3600},

    {ok, {RestartStrategy, Children}}.
