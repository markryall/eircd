-module(ei_app).

-behaviour(application).

-export([start/2, stop/1]).

-define(PORT, 7000).

start(_Type, _StartArgs) ->
    {ok, LSock} = gen_tcp:listen(?PORT, [{active, true}]),
    case ei_sup:start_link(LSock) of
	{ok, Pid} ->
	    ei_sup:start_child(),
	    {ok, Pid};
	Error ->
	    Error
    end.

stop(_State) ->
    ok.
