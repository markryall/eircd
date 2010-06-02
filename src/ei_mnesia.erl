-module(ei_mnesia).

-include_lib("stdlib/include/qlc.hrl").

-export([
	 init/0,
	 insert_nick/2,
	 insert_userinfo/5,
	 select_nick/1,
	 select_userinfo/1,
	 insert_channel/2,
	 select_channel_pids/1
	]).

-record(nick, {nick, pid}).
-record(userinfo, {nick, username, hostname, servername, realname}).
-record(channel, {pid, name}).

init() ->
    delete_schema(),

    mnesia:create_schema([node()]),
    mnesia:start(),
    mnesia:create_table(nick,
			[{attributes, record_info(fields, nick)}]),
    mnesia:create_table(userinfo,
			[{attributes, record_info(fields, userinfo)}]),
    mnesia:create_table(channel,
			[{attributes, record_info(fields, channel)}]).
delete_schema() ->
    mnesia:stop(),
    mnesia:delete_schema([node()]).

insert_nick(Nick, Pid) ->
    Fun = 
	fun() ->
		mnesia:write(#nick{nick=Nick, pid=Pid})
	end,
    mnesia:transaction(Fun).
insert_userinfo(Nick, Username, Hostname, Servername, Realname) ->
    Fun =
	fun() ->
		mnesia:write(#userinfo{nick=Nick, username=Username, hostname=Hostname, servername=Servername, realname=Realname})
	end,
    mnesia:transaction(Fun).
insert_channel(Pid, Channel) ->
    Fun =
	fun() ->
		mnesia:write(#channel{pid=Pid, name=Channel})
	end,
    mnesia:transaction(Fun).

select_nick(Pid) ->
    Fun = 
	fun() ->
		Query = qlc:q([U#nick.nick || U <- mnesia:table(nick),
				    U#nick.pid == Pid]),
		qlc:e(Query)
	end,
    {atomic, [Nick]} = mnesia:transaction(Fun),
    Nick.
select_userinfo(Nick) ->
    Fun =
	fun() ->
		Query = qlc:q([U || U <- mnesia:table(userinfo),
			    U#userinfo.nick == Nick]),
		qlc:e(Query)
	end,
    mnesia:transaction(Fun).
select_channel_pids(Channel) ->
    Fun =
	fun() ->
		Query = qlc:q([P#channel.pid || P <- mnesia:table(channel),
				    P#channel.name == Channel]),
		qlc:e(Query)
	end,
    {atomic, Pids} = mnesia:transaction(Fun),
    Pids.
