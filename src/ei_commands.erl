-module(ei_commands).

-include_lib("eunit/include/eunit.hrl").

-export([user/2, nick/2, ping/2, join/2, privmsg/2, part/2]).

user(Pid, Arguments) ->
    io:format("~p: processing user command with args ~p~n", [?MODULE, Arguments]),
    [Username, Hostname, Servername|_Realname] = Arguments,

    io:format("ei_commands -> user: ~p", [Pid]),

    Nick = ei_mnesia:select(nick, Pid),
    % TODO: replace second Username below with Realname
    ei_mnesia:insert(userinfo, Nick, Username, Hostname, Servername, Username),
    Pid ! {send, ":eircd 001 " ++ Nick ++ " :Welcome to the eircd Internet Relay Chat Network " ++ Nick ++ "\r\n"}.

nick(Pid, [Nick]) ->
    ei_event:nick_registration(Pid, Nick).

ping(Pid, _) ->
    ei_event:ping(Pid).

join(Pid, [Channel]) ->
    ei_event:join(Pid, Channel).
    

part(Pid, [Channel]) ->
    ei_event:part(Pid, Channel).

privmsg(_Socket, Arguments) ->
    io:format("~p: processing privmsg command with args~p~n", [?MODULE, Arguments]).
