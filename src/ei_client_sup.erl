-module(ei_client_sup).

-behaviour(supervisor).

-export([start_link/0, start_child/1]).
-export([init/1]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

start_child(Sock) ->
    Name = list_to_atom("ei_client_" ++ integer_to_list(round(random:uniform()*100))),
    supervisor:start_child(?MODULE, [Name, Sock]).

init(_Args) ->
    {ok, {{simple_one_for_one, 5, 1}, [child(ei_client, [])]}}.

child(Module, Args) -> {Module, {Module, start_link, Args}, temporary, 1000, worker, [Module]}.
