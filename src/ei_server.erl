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
    handle_commands(string:tokens(RawData, "\r\n"), Socket, State),
    {noreply, State};
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
		   
handle_commands([], _Socket, State) ->
    ?LOG("finished processing commands");
handle_commands([Command|Commands], Socket, State) ->
    ?LOG("processing command " ++ Command),
    case string:tokens(Command, " ") of
        [Token|Arguments] ->
            {ok, State1} = apply(ei_commands, list_to_atom(string:to_lower(Token)), [self(), Arguments, State]),
            handle_commands(Commands, Socket, State1);
        _ -> 
            ?LOG(io_lib:format("ignored command ~p", [Command])),
            handle_commands(Commands, Socket, State)
    end.

handle_cast(stop, State) -> 
    {stop, normal, State}.

handle_call(Msg, _From, State) ->
    {reply, {ok, Msg}, State}.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
