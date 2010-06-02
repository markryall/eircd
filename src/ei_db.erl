-module(ei_db).

-include_lib("stdlib/include/qlc.hrl").

-export([init/0, insert/3, insert/6, select/2, insert_channel/2, select_channel_pids/1]).

-include("ei_db.hrl").

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

insert(nick, Nick, Pid) ->
    Fun = 
	fun() ->
		mnesia:write(#nick{nick=Nick, pid=Pid})
	end,
    mnesia:transaction(Fun).
insert(userinfo, Pid, Username, Hostname, Servername, Realname) ->
    Fun =
	fun() ->
		mnesia:write(#userinfo{pid=Pid, username=Username, hostname=Hostname, servername=Servername, realname=Realname})
	end,
    mnesia:transaction(Fun).
insert_channel(Pid, Channel) ->
    Fun =
	fun() ->
		mnesia:write(#channel{pid=Pid, name=Channel})
	end,
    mnesia:transaction(Fun).

select(nick, Pid) ->
    Fun = 
	fun() ->
		Query = qlc:q([U#nick.nick || U <- mnesia:table(nick),
				    U#nick.pid == Pid]),
		qlc:e(Query)
	end,
    {atomic, [Nick]} = mnesia:transaction(Fun),
    Nick;
select(userinfo, Pid) ->
    Fun =
	fun() ->
		Query = qlc:q([U || U <- mnesia:table(userinfo),
			    U#userinfo.pid == Pid]),
		qlc:e(Query)
	end,
    {atomic, [User]} = mnesia:transaction(Fun),
    User.
select_channel_pids(Channel) ->
    Fun =
	fun() ->
		Query = qlc:q([P#channel.pid || P <- mnesia:table(channel),
				    P#channel.name == Channel]),
		qlc:e(Query)
	end,
    {atomic, Pids} = mnesia:transaction(Fun),
    Pids.
