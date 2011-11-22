-module(ei_mod_ping).

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

-include_lib("ei_logging.hrl").

-record(state, {}).

init([]) ->
    {ok, #state{}}.

terminate(_Reason, State) ->
    {noreply, State}.

handle_call(Msg, State) ->
    {reply, {ok, Msg}, State}.

handle_info({tcp_closed, _Port}, State) ->
    {noreply, State}.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

handle_event({user_ping, {Pid}}, State) ->
    ?LOG("processing ping command"),
    Pid ! {send, "PONG\r\n"},
    {ok, State};
handle_event(_, State) ->
    {ok, State}.
