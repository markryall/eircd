-module(ei_mod_nick).

-export([init/1, handle_event/2]).

-include_lib("ei_logging.hrl").
-include_lib("ei_common.hrl").

init(_Args) ->
    {ok, []}.

handle_event({_Pid, <<"NICK ", Nick/binary>>}, State) ->
    ?LOG(io_lib:format("processing nick registration event with nick: ~p", [Nick])),
    {ok, State#state{nick=Nick}};
handle_event(_, State) ->
    {ok, State}.
