-module(ei_commands).

-include_lib("eunit/include/eunit.hrl").

-export([user/2, nick/2, ping/2, join/2, privmsg/2, part/2]).

user(Pid, Arguments) ->
    io:format("~p: processing user command with args ~p~n", [?MODULE, Arguments]),
    [Username, Hostname, Servername|_Realname] = Arguments,

    io:format("ei_commands -> user: ~p", [Pid]),

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
