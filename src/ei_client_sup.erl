-module(ei_client_sup).

-behaviour(supervisor).

-export([start_link/0, start_child/1]).
-export([init/1]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

start_child(Sock) ->
    Name = integer_to_list(round(random:uniform()*100)),
    supervisor:start_child(?MODULE, [Sock]).

init(_Args) ->
    {ok, {{simple_one_for_one, 1, 1000}, [child(ei_client, [])]}}.

child(Module, Args) -> {Module, {Module, start_link, Args}, permanent, 1000, worker, [Module]}.
