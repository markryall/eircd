-module(ei_commands).

-export([user/3, nick/3, ping/3, join/3, privmsg/3, part/3, parse_and_handle/3]).

-include_lib("ei_logging.hrl").
-include_lib("ei_common.hrl").

parse_and_handle(RawData, Socket, State) ->
    ?LOG(io_lib:format("RAW: ~p", [RawData])),
    handle(string:tokens(RawData, "\r\n"), Socket, State).

handle([], _Socket, State) ->
    ?LOG("finished processing commands"),
    {ok, State};
handle([Command|Commands], Socket, State) ->
    ?LOG("processing command " ++ Command),
    case string:tokens(Command, " ") of
        [Token|Arguments] ->
            {ok, State1} = apply(ei_commands, list_to_atom(string:to_lower(Token)), [self(), Arguments, State]),
            handle(Commands, Socket, State1);
        _ -> 
            ?LOG(io_lib:format("ignored command ~p", [Command])),
            handle(Commands, Socket, State)
    end.

user(Pid, Arguments, State) ->
    ?LOG(io_lib:format("processing user command with args ~p", [Arguments])),
    [Username, Hostname, Servername|_Realname] = Arguments,

    ?LOG(io_lib:format("user: ~p", [Pid])),

    % TODO: replace second Username below with Realname
    apply(ei_mod_userinfo, handle_event, [{user_userinfo_registration, {Pid, Username, Hostname, Servername, Username}}, State]).

nick(Pid, [Nick], State) ->
    apply(ei_mod_nick, handle_event, [{user_nick_registration, {Pid, Nick}}, State]).

ping(Pid, _, State) ->
    apply(ei_mod_ping, handle_event, [{user_ping, {Pid}}, State]).

join(Pid, [Channel], State) ->
    apply(ei_mod_join, handle_event, [{user_join, {Pid, Channel}}, State]).
    
part(Pid, [Channel], State) ->
    apply(ei_mod_part, handle_event, [{user_part, {Pid, Channel}}, State]).

privmsg(Pid, Args, State) ->
    [Channel|Msg] = Args,
    apply(ei_mod_privmsg, handle_event, [{user_privmsg, {Pid, Channel, Msg}}, State]).
