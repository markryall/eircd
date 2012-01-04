-module(ei_mod_privmsg).

-export([
	 handle_event/2
	 ]).

handle_event({user_privmsg, {_Pid, _Channel, _Msg}}, State) ->
    io:format("~p: processing ~p event~n", [?MODULE, "user_privmsg"]),
    %Pids = lists:delete(Pid, ei_user:get_channel_pids(Channel)),
    %Nick = ei_user:get_nick(Pid),
    %UserInfo = ei_user:get_userinfo(Pid),
    %ei_user:broadcast_message(Pids, io_lib:format("~s: Message from ~s: ~s\r\n", [UserInfo#userinfo.hostname, Nick,Msg])),
    {ok, State};
handle_event(_, State) ->
    {ok, State}.
