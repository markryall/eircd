-module(ei_mod_privmsg).

-behaviour(gen_event).

-export([
	 init/1,
	 add_handler/0,
	 delete_handler/0
	 ]).
-export([
	 handle_event/2,
	 handle_call/2,
	 handle_info/2,
	 code_change/3,
	 terminate/2
	 ]).

-record(state, {}).

init([]) ->
    {ok, #state{}}.

add_handler() ->
    ei_event:add_handler(?MODULE, []).

delete_handler() ->
    ei_event:delete_handler(?MODULE, []).

terminate(_Reason, State) ->
    {noreply, State}.

handle_call(Msg, State) ->
    {reply, {ok, Msg}, State}.

handle_info(_, State) ->
    {noreply, State}.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

handle_event({user_privmsg, {Pid, Nick, Channel, Msg}}, State) ->
    io:format("~p: processing ~p event~n", [?MODULE, "user_privmsg"]),
    Pids = lists:delete(Pid, ei_user:get_channel_pids(Channel)),
    ei_user:broadcast_message(Pids, "Message from " ++ Nick ++ ": " ++ Msg ++ "\r\n"),
    {ok, State};
handle_event(_, State) ->
    {ok, State}.
