-module(ei_server).

-behaviour(gen_server).

-export([
	 start_link/1,
	 stop/0
	]).
-export([
	 terminate/2,
	 init/1,
	 handle_info/2,
	 handle_cast/2,
	 handle_call/3,
	 code_change/3
	]).

-include_lib("ei_logging.hrl").
-include_lib("ei_common.hrl").

-define(SERVER, ?MODULE).

start_link(LSock) ->
    ?LOG("start_link"),
    gen_server:start_link(?MODULE, [LSock], []).

stop() ->
    gen_server:cast(?SERVER, stop).

terminate(_Reason, State) ->
    {noreply, State}.

init([LSock]) ->
    ?LOG("init"),
    {ok, #state{lsock = LSock}, 0}.

handle_info({tcp, Socket, RawData}, State) ->
    ?LOG(io_lib:format("received data ~p on socket ~p~n", [RawData, Socket])),
    {ok, State1} = ei_commands:handle(string:tokens(RawData, "\r\n"), Socket, State),
    {noreply, State1};
handle_info({tcp_closed, Port}, State) ->
	?LOG(io_lib:format("socket on port ~p closed", [Port])),
	{noreply, State};
handle_info(timeout, #state{lsock = LSock} = _State) ->
    ?LOG(io_lib:format("waiting for connection on socket ~p", [LSock])),
    {ok, Sock} = gen_tcp:accept(LSock),
    ?LOG(io_lib:format("received new connection on socket ~p", [Sock])),
    ei_server_sup:start_child(),
    {noreply, #state{lsock=LSock, socket=Sock}};
handle_info({send, Msg}, #state{socket=Sock} = State) ->
    gen_tcp:send(Sock, Msg),
    {noreply, State}.
		   
handle_cast(stop, State) -> 
    {stop, normal, State}.

handle_call(Msg, _From, State) ->
    {reply, {ok, Msg}, State}.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
