-module(ei_sup).

-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

init([]) ->
    io:format("ei_sup off we go ...~n"),
    Server = {ei_server, {ei_server, start_link, []},
	      permanent, 2000, worker, [ei_server]},
    {ok, {{one_for_one, 0, 1}, [Server]}}.
