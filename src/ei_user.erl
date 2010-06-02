-module(ei_user).

-export([
	 get_nick/1,
	 store_nick/2,
	 get_userinfo/1,
	 store_userinfo/5,
	 join/2,
	 get_channel_pids/1,
	 broadcast_message/2
	]).

get_nick(Pid) ->
    ei_mnesia:select_nick(Pid).

store_nick(Nick, Pid) ->
    ei_mnesia:insert_nick(Nick, Pid).

get_userinfo(Nick) ->
    ei_mnensia:select_userinfo(Nick).

store_userinfo(Nick, Username, Hostname, Servername, Realname) ->
    ei_mnesia:insert_userinfo(Nick, Username, Hostname, Servername, Realname).

join(Pid, Channel) ->
    ei_mnesia:insert_channel(Pid, Channel).

get_channel_pids(Channel) ->
    ei_mnesia:select_channel_pids(Channel).

broadcast_message([], _Msg) ->
    done;
broadcast_message([H|T], Msg) ->
    H ! {send, Msg},
    broadcast_message(T, Msg).
