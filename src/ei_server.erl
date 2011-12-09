-module(ei_server).

-export([start_link/1, stop/0]).

start_link(Port) ->
    {ok, Sock} = gen_tcp:listen(Port, [binary, {active, true}]),
    {ok, spawn_link(fun() -> loop(Sock) end)}.

stop() -> exit(whereis({local, ?MODULE}), shutdown).

loop(SSock) ->
    {ok, CSock} = gen_tcp:accept(SSock),
    {ok, Pid} = ei_client_sup:start_child(CSock),
    ok = gen_tcp:controlling_process(CSock, Pid),
    loop(SSock).

