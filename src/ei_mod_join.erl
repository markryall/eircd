-module(ei_mod_join).

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

handle_info({tcp_closed, _Port}, State) ->
    {noreply, State}.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

handle_event({user_join, {Pid, Channel}}, State) ->
    io:format("~p: processing join command with channel=~p~n", [?MODULE, Channel]),
    Nick = ei_mnesia:select(nick, Pid),
    Pid ! {send, ":eircd MODE " ++ Channel ++ " +ns\r\n"},
    Pid ! {send, ":eircd 353 " ++ Nick ++ " @ " ++ Channel ++ " :@" ++ Nick ++ "\r\n"},
    Pid ! {send, ":eircd 366 " ++ Nick ++ " " ++ Channel ++ " :End of /NAMES list.\r\n"},
    {ok, State};
handle_event(_, State) ->
    {ok, State}.
