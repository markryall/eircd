-module(ei_server2).

-behaviour(gen_server).

-export([
	 start_link/1,
	 get_count/0
	]).
-export([
	 terminate/2,
	 init/1,
	 handle_info/2,
	 handle_cast/2,
	 handle_call/3,
	 code_change/3
	]).

-define(SERVER, ?MODULE).

-record(state, {lsock}).

start_link(LSock) ->
    gen_server:start_link(?MODULE, [LSock], []).

stop() ->
    gen_server:cast(?SERVER, stop).

get_count() ->
    gen_server:call(?SERVER, get_count).

terminate(_Reason, State) ->
    {noreply, State}.

init([LSock]) ->
    {ok, #state{lsock = LSock}, 0}.

handle_info({tcp, Socket, RawData}, State) ->
    io:format("handle_info: ~p~n", [RawData]),
    {noreply, State};
handle_info(timeout, #state{lsock = LSock} = State) ->
    io:format("handle_info: timeout occurred"),
    {ok, _Sock} = gen_tcp:accept(LSock),
    ei_sup:start_child(),
    {noreply, State}.

handle_cast(stop, State) ->
    {stop, normal, State}.

handle_call(Msg, _From, State) ->
    {reply, {ok, Msg}, State}.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
