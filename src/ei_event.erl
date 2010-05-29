-module(ei_event).

-export([
	 start_link/0,
	 nick_registration/2,
      	 add_handler/2,
	 delete_handler/2,
	 ping/1,
	 join/2,
	 part/2
	 ]).

-define(SERVER, ?MODULE).

start_link() ->
    gen_event:start_link({local, ?SERVER}).

add_handler(Handler, Args) ->
    gen_event:add_handler(?SERVER, Handler, Args).

delete_handler(Handler, Args) ->
    gen_event:delete(?SERVER, Handler, Args).

nick_registration(Pid, Nick) ->
    gen_event:notify(?SERVER, {user_nick_registration, {Pid, Nick}}).

ping(Pid) ->
    gen_event:notify(?SERVER, {user_ping, {Pid}}).

join(Pid, Channel) ->
    gen_event:notify(?SERVER, {user_join, {Pid, Channel}}).

part(Pid, Channel) ->
    gen_event:notify(?SERVER, {user_part, {Pid, Channel}}).
