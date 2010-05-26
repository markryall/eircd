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

handle_commands([], Socket) ->
    io:format("~p: finished processing commands~n", [?MODULE]);
handle_commands([Command|Commands], Socket) ->
    io:format("~p: processing command ~p~n", [?MODULE, Command]),
    case string:tokens(Command, " ") of
        ["USER", Username, Hostname, Servername, Realname] ->
            {atomic,[{nick,Nick,_Pid}]} = ei_mnesia:select(nick, self()),
            ei_mnesia:insert(userinfo, Nick, Username, Hostname, Servername, Realname),
            gen_tcp:send(Socket, ":eircd 001 " ++ Nick ++ " :Welcome to the eircd Internet Relay Chat Network " ++ Nick ++ "\r\n");
        ["NICK", Nick] ->
            io:format("~p: processing nick command with nick=~p~n", [?MODULE, Nick]),
            ei_mnesia:insert(nick, Nick, self());
        ["JOIN", Channel] ->
            io:format("~p: processing join command with channel=~p~n", [?MODULE, Channel]),
            {atomic,[{nick,Nick,_Pid}]} = ei_mnesia:select(nick, self()),
            gen_tcp:send(Socket, ":eircd MODE " ++ Channel ++ " +ns\r\n"),
            gen_tcp:send(Socket, ":eircd 353 " ++ Nick ++ " @ " ++ Channel ++ " :@" ++ Nick ++ "\r\n"),
            gen_tcp:send(Socket, ":eircd 366 " ++ Nick ++ " " ++ Channel ++ " :End of /NAMES list.\r\n");
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


