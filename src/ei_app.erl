-module(ei_app).

-behaviour(application).

-export([start/2, stop/1]).

-define(PORT, 6667).

start(_Type, _StartArgs) ->
    ei_server_sup:start_link(?PORT),
    ei_client_sup:start_link(),
    start_event_manager(),
    {ok, self()}.

stop(_State) ->
    ok.

start_event_manager() ->
    gen_event:start_link({local, event_manager}),
    %gen_event:add_handler(event_manager, ei_mod_nick, []),
    gen_event:add_handler(event_manager, ei_mod_join, []),
    gen_event:add_handler(event_manager, ei_mod_part, []),
    gen_event:add_handler(event_manager, ei_mod_registration, []). 

