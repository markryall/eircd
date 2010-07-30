-module(ei_commands).

-export([user/2, nick/2, ping/2, join/2, privmsg/2, part/2]).

-include_lib("ei_logging.hrl").

user(Pid, Arguments) ->
    ?LOG(io_lib:format("processing user command with args ~p", [Arguments])),
    [Username, Hostname, Servername|_Realname] = Arguments,

    ?LOG(io_lib:format("user: ~p", [Pid])),

    % TODO: replace second Username below with Realname
    ei_event:userinfo_registration(Pid, Username, Hostname, Servername, Username).


nick(Pid, [Nick]) ->
    ei_event:nick_registration(Pid, Nick).

ping(Pid, _) ->
    ei_event:ping(Pid).

join(Pid, [Channel]) ->
    ei_event:join(Pid, Channel).
    

part(Pid, [Channel]) ->
    ei_event:part(Pid, Channel).

privmsg(Pid, Args) ->
    [Channel|Msg] = Args,
    ei_event:privmsg(Pid, Channel, Msg).
