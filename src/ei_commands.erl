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
    nick(binary_to_list(Nick), State);
process_command(<<"USER ", Arguments/binary>>, State) ->
    user(self(), string:tokens(binary_to_list(Arguments), " "), State);
process_command(<<"PING">>, State) ->
    ping(self(), undefined, State);
process_command(<<"JOIN ", Channel/binary>>, State) ->
    join(self(), binary_to_list(Channel), State); 
process_command(<<"PART ", Channel/binary>>, State) ->
    part(self(), binary_to_list(Channel), State);
process_command(Command, State) ->
    {ok, State}.

user(Pid, Arguments, State) ->
    %?LOG(io_lib:format("processing user command with args ~p", [Arguments])),
    [Username, Hostname, Servername|_Realname] = Arguments,

    % TODO: replace second Username below with Realname
    apply(ei_mod_userinfo, handle_event, [{user_userinfo_registration, {Pid, Username, Hostname, Servername, Username}}, State]).

nick(Nick, State) ->
    apply(ei_mod_nick, handle_event, [{user_nick_registration, {Nick}}, State]).

ping(Pid, _, State) ->
    apply(ei_mod_ping, handle_event, [{user_ping, {Pid}}, State]).

join(Pid, Channel, State) ->
    apply(ei_mod_join, handle_event, [{user_join, {Pid, Channel}}, State]).
    
part(Pid, Channel, State) ->
    apply(ei_mod_part, handle_event, [{user_part, {Pid, Channel}}, State]).

privmsg(Pid, Args, State) ->
    [Channel|Msg] = Args,
    apply(ei_mod_privmsg, handle_event, [{user_privmsg, {Pid, Channel, Msg}}, State]).
