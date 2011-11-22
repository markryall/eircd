-module(ei_commands).

-export([user/3, nick/3, ping/3, join/3, privmsg/3, part/3]).

-include_lib("ei_logging.hrl").

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
