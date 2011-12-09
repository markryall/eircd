-module(ei_client).

-behaviour(gen_server).

-export([start_link/1]).
-export([terminate/2, init/1, handle_info/2, handle_cast/2, handle_call/3, code_change/3]).

-include_lib("ei_common.hrl").
-include_lib("ei_logging.hrl").

start_link(Sock) ->
    gen_server:start_link(?MODULE, Sock, []).

terminate(_Reason, State) ->
    {noreply, State}.

init(Socket) ->
    {ok, #state{socket = Socket}, 0}.

handle_info({tcp, _Socket, RawData}, State) ->
    ?LOG(io_lib:format("got message: ~p", [RawData])),
    {ok, NewState} = ei_commands:parse_and_handle(binary:split(RawData, [<<"\r\n">>], [global]), State),
    {noreply, NewState};
handle_info({send, Msg}, #state{socket=Sock} = State) ->
    gen_tcp:send(Sock, Msg),
    {noreply, State};
handle_info(Msg, State) ->
    ?LOG(io_lib:format("got unknown message: ~p", [Msg])),
    {noreply, State}.
		   
handle_cast(stop, State) -> {stop, normal, State}.

handle_call(Msg, _From, State) -> 
    ?LOG(io_lib:format("got message: ~p", [Msg])),
    {reply, {ok, Msg}, State}.

code_change(_OldVsn, State, _Extra) -> {ok, State}.
