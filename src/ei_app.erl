-module(ei_app).

-behaviour(application).

-export([start/2, stop/1]).

-define(PORT, 6667).

start(_Type, _StartArgs) ->
    ei_client_sup:start_link(),
    ei_server_sup:start_link(?PORT).

stop(_State) ->
    ok.
