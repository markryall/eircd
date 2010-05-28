-module(ei_privmsg).

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

init([]) ->
    ei_event:add_handler(?MODULE, []).

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

handle_event({create, {Key, Value}}, State) ->
    io:format("handle_event: create(~w, ~w)", [Key, Value]),
    {ok, State};
handle_event({lookup, Key}, State) ->
    io:format("handle_event: lookup(~w)", [Key]),
    {ok, State}.
