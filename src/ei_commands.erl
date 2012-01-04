-module(ei_commands).

-export([parse_and_handle/2]).

-include_lib("ei_logging.hrl").
-include_lib("ei_common.hrl").

parse_and_handle(RawData, State) ->
    {ok, handle(RawData, State)}.

handle([], State) ->
    ?LOG("finished processing commands"),
    State;
handle([Command|Commands], State) ->
    ?LOG(io_lib:format("processing command ~p", [Command])),

    {ok, State1} = process_command(Command, State),
    handle(Commands, State1).

process_command(<<"NICK ", Nick/binary>>, State) ->
    ei_mod_nick:handle_event({user_nick_registration, {binary_to_list(Nick)}}, State);
process_command(<<"USER ", Arguments/binary>>, State) ->
    [Username, Hostname, Servername|_Realname] = string:tokens(binary_to_list(Arguments), " "),
    ei_mod_userinfo:handle_event({user_userinfo_registration, {self(), Username, Hostname, Servername, Username}}, State);
process_command(<<"PING">>, State) ->
    ei_mod_ping:handle_event({user_ping, {self()}}, State);
process_command(<<"JOIN ", Channel/binary>>, State) ->
    ei_mod_join:handle_event({user_join, {self(), binary_to_list(Channel)}}, State);
process_command(<<"PART ", Channel/binary>>, State) ->
    ei_mod_part:handle_event({user_part, {self(), binary_to_list(Channel)}}, State);
process_command(_Command, State) ->
    {ok, State}.

