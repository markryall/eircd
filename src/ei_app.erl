-module(ei_app).

-behaviour(application).

-export([start/2, stop/1]).

start(Type, StartArgs) ->
    case ei_sup:start_link() of
	{ok, Pid} ->
	    {ok, Pid};
	Error  ->
	    Error
    end.

stop(State) ->
    ok.
