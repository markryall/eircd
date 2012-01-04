-module(ei_mod_registration).

-export([init/1, handle_event/2]).

-include_lib("ei_logging.hrl").

-record(state, {nick, username, hostname, servername, realname}).

init(_Args) -> {ok, #state{}}.

handle_event({Pid, <<"NICK ", Nick/binary>>}, State) ->
    {ok, State#state{nick=Nick}};
handle_event({Pid, <<"USER ", Arguments/binary>>}, #state{nick = Nick} = State) ->
    [Username, Hostname, Servername|Realname] = string:tokens(binary_to_list(Arguments), " "),
    Pid ! {send, io_lib:format(":eircd 001 ~s :Welcome to the eircd Internet Relay Chat Network ~s\r\n", [binary_to_list(Nick), binary_to_list(Nick)])},
    {ok, State};
    %{remove_handler};
handle_event(_, State) -> {ok, State}.
