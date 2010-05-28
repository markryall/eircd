-module(ei_commands).

-include_lib("eunit/include/eunit.hrl").

-export([user/2, nick/2, ping/2, join/2]).

user(Socket, Arguments) ->
    io:format("~p: processing user command with args ~p~n", [?MODULE, Arguments]),
    [Username, Hostname, Servername|_Realname] = Arguments,
    {atomic,[{nick,Nick,_Pid}]} = ei_mnesia:select(nick, self()),
    % TODO: replace second Username below with Realname
    ei_mnesia:insert(userinfo, Nick, Username, Hostname, Servername, Username),
    gen_tcp:send(Socket, ":eircd 001 " ++ Nick ++ " :Welcome to the eircd Internet Relay Chat Network " ++ Nick ++ "\r\n").

nick(_Socket, [Nick]) ->
    io:format("~p: processing nick command with nick=~p~n", [?MODULE, Nick]),
    ei_mnesia:insert(nick, Nick, self()),
    ei_event:nick_registration(Nick).

ping(Socket, Arguments) ->
    io:format("~p: processing ping command~n", [?MODULE]),
    gen_tcp:send(Socket, "PONG\r\n").

join(Socket, [Channel]) ->
    io:format("~p: processing join command with channel=~p~n", [?MODULE, Channel]),
    {atomic,[{nick,Nick,_Pid}]} = ei_mnesia:select(nick, self()),
    gen_tcp:send(Socket, ":eircd MODE " ++ Channel ++ " +ns\r\n"),
    gen_tcp:send(Socket, ":eircd 353 " ++ Nick ++ " @ " ++ Channel ++ " :@" ++ Nick ++ "\r\n"),
    gen_tcp:send(Socket, ":eircd 366 " ++ Nick ++ " " ++ Channel ++ " :End of /NAMES list.\r\n").
