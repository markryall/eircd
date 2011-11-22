-module(ei_mod_privmsg).

-behaviour(gen_event).

-export([
	 init/1
	 ]).
-export([
	 handle_event/2,
	 handle_call/2,
	 handle_info/2,
	 code_change/3,
	 terminate/2
	 ]).

-include("ei_db.hrl").

-record(state, {}).

init([]) ->
    {ok, #state{}}.

terminate(_Reason, State) ->
    {noreply, State}.

handle_call(Msg, State) ->
    {reply, {ok, Msg}, State}.

handle_info(_, State) ->
    {noreply, State}.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

handle_event({user_privmsg, {Pid, Channel, Msg}}, State) ->
    io:format("~p: processing ~p event~n", [?MODULE, "user_privmsg"]),
    Pids = lists:delete(Pid, ei_user:get_channel_pids(Channel)),
    Nick = ei_user:get_nick(Pid),
    UserInfo = ei_user:get_userinfo(Pid),
    ei_user:broadcast_message(Pids, io_lib:format("~s: Message from ~s: ~s\r\n", [UserInfo#userinfo.hostname, Nick,Msg])),
    {ok, State};
handle_event(_, State) ->
    {ok, State}.
