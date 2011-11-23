-module(ei_mod_nick).

-export([
	 handle_event/2
	 ]).

-include_lib("ei_logging.hrl").

handle_event({user_nick_registration, {Pid, Nick}}, State) ->
    ?LOG(io_lib:format("processing nick registration event with nick: ~p", [Nick])),
    ei_user:store_nick(Nick, Pid),
    {ok, State};
handle_event(_, State) ->
    {ok, State}.
