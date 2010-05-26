-module(ei_app).

-include_lib("eunit/include/eunit.hrl").

-behaviour(application).

-export([start/2, stop/1]).

-define(PORT, 6667).

start(_Type, _StartArgs) ->
    ei_mnesia:init(),

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
