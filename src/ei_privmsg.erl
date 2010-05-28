-module(ei_privmsg).

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
    io:format("handle_catt: ~p", [Msg]),
    {reply, {ok, Msg}, State}.

handle_info({tcp_closed, _Port}, State) ->
    io:format("handle_info"),
    {noreply, State}.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

handle_event(Ignored, State) ->
    io:format("~p: ignoring event ~p~n",[?MODULE,Ignored]),
    {ok, State}.
% handle_event({user_nick_registration, Nick}, State) ->
%     io:format("nick registeration: " ++ Nick),
%     {ok, State}.