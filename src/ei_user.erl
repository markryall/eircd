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
    ei_db:select_nick(Pid).

store_nick(Nick, Pid) ->
    ei_db:insert_nick(Nick, Pid).

get_userinfo(Pid) ->
    ei_db:select_userinfo(Pid).

store_userinfo(Pid, Username, Hostname, Servername, Realname) ->
    ei_db:insert_userinfo(Pid, Username, Hostname, Servername, Realname).

join(Pid, Channel) ->
    ei_db:insert_channel(Pid, Channel).

get_channel_pids(Channel) ->
    ei_db:select_channel_pids(Channel).

broadcast_message([], _Msg) ->
    done;
broadcast_message([H|T], Msg) ->
    H ! {send, Msg},
    broadcast_message(T, Msg).
