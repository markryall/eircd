-module(ei_mod_userinfo).

-export([
	 handle_event/2
	 ]).

-include_lib("ei_logging.hrl").
-include_lib("ei_common.hrl").

handle_event({user_userinfo_registration, {Pid, Username, Hostname, Servername, Realname}}, State) ->
    ?LOG("processing userinfo registration event"),
    Nick = State#state.nick,
    Pid ! {send, io_lib:format(":eircd 001 ~s :Welcome to the eircd Internet Relay Chat Network ~s\r\n", [Nick, Nick])},
    {ok, State#state{username=Username, hostname=Hostname, servername=Servername, realname=Realname}};
handle_event(_, State) ->
    {ok, State}.
