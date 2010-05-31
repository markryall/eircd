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
	    ei_mod_nick:add_handler(),
	    ei_mod_userinfo:add_handler(),
	    ei_mod_ping:add_handler(),
	    ei_mod_join:add_handler(),
	    ei_mod_part:add_handler(),
	    ei_mod_privmsg:add_handler(),
	    ei_server_sup:start_child(),
	    {ok, Pid};
	Other ->
	    {error, Other}
    end.

stop(_State) ->
    ok.
