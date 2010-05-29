-module(ei_user).

-export([get_nick/1, store_nick/2, get_userinfo/1, store_userinfo/5]).

get_nick(Pid) ->
    ei_mnesia:select(nick, Pid).

store_nick(Nick, Pid) ->
    ei_mnesia:insert(nick, Nick, Pid).

get_userinfo(Nick) ->
    ei_mnensia:select(userinfo, Nick).

store_userinfo(Nick, Username, Hostname, Servername, Realname) ->
    ei_mnesia:insert(userinfo, Nick, Username, Hostname, Servername, Realname).
