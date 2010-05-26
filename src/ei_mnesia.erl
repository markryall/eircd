-module(ei_mnesia).

-include_lib("stdlib/include/qlc.hrl").

-export([init/0, insert/3, insert/6, select/2]).

-record(user, {nick, pid}).
-record(userinfo, {nick, username, hostname, servername, realname}).

init() ->
    delete_schema(),

    mnesia:create_schema([node()]),
    mnesia:start(),
    mnesia:create_table(user,
			[{attributes, record_info(fields, user)}]),
    mnesia:create_table(userinfo,
			[{attributes, record_info(fields, userinfo)}]).
delete_schema() ->
    mnesia:stop(),
    mnesia:delete_schema([node()]).

insert(nick, Nick, Pid) ->
    Fun = 
	fun() ->
		mnesia:write(#user{nick=Nick, pid=Pid})
	end,
    mnesia:transaction(Fun).
insert(userinfo, Nick, Username, Hostname, Servername, Realname) ->
    Fun =
	fun() ->
		mnesia:write(#userinfo{nick=Nick, username=Username, hostname=Hostname, servername=Servername, realname=Realname})
	end,
    mnesia:transaction(Fun).

select(nick, Pid) ->
    Fun = 
	fun() ->
		Query = qlc:q([U || U <- mnesia:table(user),
				    U#user.pid == Pid]),
		qlc:e(Query)
	end,
    mnesia:transaction(Fun);
select(userinfo, Nick) ->
    Fun =
	fun() ->
		Query = qlc:q([U || U <- mnesia:table(userinfo),
			    U#userinfo.nick == Nick]),
		qlc:e(Query)
	end,
    mnesia:transaction(Fun).
