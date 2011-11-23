-module(ei_app).

-behaviour(application).

-export([start/2, stop/1]).

-define(PORT, 6667).

start(_Type, _StartArgs) ->
    {ok, LSock} = gen_tcp:listen(?PORT, [binary, {active, true}]),
    case ei_sup:start_link(LSock) of
	{ok, Pid} ->
	    ei_server_sup:start_child(),
	    {ok, Pid};
	Other ->
	    {error, Other}
    end.

stop(_State) ->
    ok.
