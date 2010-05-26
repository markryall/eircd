-module(ei_mnesia).

-include_lib("stdlib/include/qlc.hrl").

-export([init/0, insert/2, select/1]).

-record(user, {nick, pid}).

init() ->
    delete_schema(),

    mnesia:create_schema([node()]),
    mnesia:start(),
    mnesia:create_table(user,
			 [{attributes, record_info(fields, user)}]).
delete_schema() ->
    mnesia:stop(),
    mnesia:delete_schema([node()]).

insert(Nick, Pid) ->
    Fun = 
	fun() ->
		mnesia:write(#user{nick=Nick, pid=Pid})
	end,
    mnesia:transaction(Fun).

select(Pid) ->
    Fun = 
	fun() ->
		User = #user{pid = Pid, nick = '$1', _ = '_'},
		mnesia:select(user, [{User, [], ['$1']}])
	end,
    mnesia:transaction(Fun).
