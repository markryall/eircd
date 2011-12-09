-module(ei_server_sup).

-behaviour(supervisor).

-export([start_link/1]).
-export([init/1]).

start_link(Port) ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, Port).

init(Port) ->
    {ok, {{one_for_one, 5, 2000}, [child(ei_server, [Port])]}}.

child(Module, Args) -> {Module, {Module, start_link, Args}, permanent, 1000, worker, [Module]}.
