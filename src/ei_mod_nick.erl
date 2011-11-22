-module(ei_mod_nick).

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

handle_info(_, State) ->
    {noreply, State}.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

handle_event({user_nick_registration, {Pid, Nick}}, State) ->
    ?LOG(io_lib:format("processing nick registration event with nick: ~p", [Nick])),
    ei_user:store_nick(Nick, Pid),
    {ok, State};
handle_event(_, State) ->
    {ok, State}.
