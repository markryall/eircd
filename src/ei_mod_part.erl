-module(ei_mod_part).

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

handle_event({user_part, {Pid, Channel}}, State) ->
    io:format("~p: processing part command with channel=~p~n", [?MODULE, Channel]),
    Nick = ei_mnesia:select_nick(Pid),
    Pid ! {send, io_lib:format(":~s!user@host PART ~s\r\n",[Nick, Channel])},
    {ok, State};
handle_event(_, State) ->
    {ok, State}.
