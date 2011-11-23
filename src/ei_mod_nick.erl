-module(ei_mod_nick).

-export([
	 handle_event/2
	 ]).

-include_lib("ei_logging.hrl").
-include_lib("ei_common.hrl").

handle_event({user_nick_registration, {Nick}}, State) ->
    ?LOG(io_lib:format("processing nick registration event with nick: ~p", [Nick])),
    {ok, State#state{nick=Nick}};
handle_event(_, State) ->
    {ok, State}.
