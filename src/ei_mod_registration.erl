-module(ei_mod_registration).

-export([init/1, handle_event/2]).

-include_lib("ei_common.hrl").
-include_lib("ei_logging.hrl").

init(_Args) -> {ok, #state{}}.

handle_event({nick, {Pid, <<Nick/binary>>}}, State) ->
    ei_db:user_registration(Pid, binary_to_list(Nick)), 
    {ok, State#state{nick=Nick}};
handle_event({user, {Pid, <<Arguments/binary>>}}, #state{nick = Nick} = State) ->
    [Username, Hostname, _Servername|_Realname] = string:tokens(binary_to_list(Arguments), " "),
    Pid ! {send, io_lib:format(":eircd 001 ~s :Welcome to the eircd Internet Relay Chat Network ~s\r\n", [binary_to_list(Nick), binary_to_list(Nick)])},
    {ok, State#state{username=Username, hostname=Hostname}};
    %{remove_handler};
handle_event(_, State) -> {ok, State}.
