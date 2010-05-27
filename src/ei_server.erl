-module(ei_server).

-include_lib("eunit/include/eunit.hrl").

-behaviour(gen_server).

-export([
	 start_link/1,
	 get_count/0,
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
    io:format("~p: received data ~p on socket ~p~n", [?MODULE, RawData, Socket]),
    handle_commands(string:tokens(RawData, "\r\n"), Socket),
    {noreply, State};
handle_info({tcp_closed, Port}, State) ->
	io:format("~p: socket on port ~p closed~n", [?MODULE, Port]),
	{noreply, State};
handle_info(timeout, #state{lsock = LSock} = State) ->
    io:format("~p: waiting for connection on socket ~p~n", [?MODULE, LSock]),
    {ok, Sock} = gen_tcp:accept(LSock),
    io:format("~p: received new connection on socket ~p~n", [?MODULE, Sock]),
    ei_sup:start_child(),
    {noreply, State}.

handle_commands([], _Socket) ->
    io:format("~p: finished processing commands~n", [?MODULE]);
handle_commands([Command|Commands], Socket) ->
    io:format("~p: processing command ~p~n", [?MODULE, Command]),
    case string:tokens(Command, " ") of
        [Token|Arguments] ->
            try
                apply(ei_commands, list_to_atom(string:to_lower(Token)), [Socket, Arguments])
            catch
                error:undef -> io:format("~p: failed to apply function ~p~n", [?MODULE, Token])
            end;
        _ -> io:format("~p: ignored command ~p~n", [?MODULE, Command])
    end,
    handle_commands(Commands, Socket).

handle_cast(stop, State) ->
    {stop, normal, State}.

handle_call(Msg, _From, State) ->
    {reply, {ok, Msg}, State}.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

terminate_test_() ->
    [?_assert(ei_server:terminate(reason, state) =:= {noreply, state})].


