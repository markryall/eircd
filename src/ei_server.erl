-module(ei_server).

-behaviour(gen_server).

-export([
	 start_link/1,
	 start_link/0,
	 get_count/0,
         wait_connect/1
	]).
-export([
	 terminate/2,
	 init/1,
	 handle_info/2,
	 handle_cast/2,
	 handle_call/3,
	 code_change/3
	]).

-define(DEFAULT_PORT, 7000).
-define(SERVER, ?MODULE).

%% needs to represent the server state
-record(state, {}).

start_link() ->
    start_link(?DEFAULT_PORT).

start_link(Port) ->
    io:format("ei_server: starting up on ~p~n", [Port]),

    %% 1st arg, {local, ?SERVER} - register local process as ?SERVER
    %% 2nd arg, ?MODULE - module that contains the init function
    %% 3rd arg, [Port] - parameters to pass to init
    %% 4th arg, [] - extra flags that can be passed to start_link
    gen_server:start_link({local, ?SERVER}, ?MODULE, [Port], []).

stop() ->
    gen_server:cast(?SERVER, stop).

get_count() ->
    gen_server:call(?SERVER, get_count).

terminate(_Reason, State) ->
    {noreply, State}.

init([Port]) ->
    case gen_tcp:listen(Port,[{active, false}]) of
	{ok, LSock} ->
	    io:format("~p: Got a socket listener~n", [?MODULE]),
            spawn(?MODULE, wait_connect, [LSock]);
	Other ->
	    io:format("Can't listen to socket ~p~n", [Other])
    end,
    {ok, #state{}}.

wait_connect(LS) ->
    io:format("Waiting for connection~n"),
    case gen_tcp:accept(LS) of
	{ok, Socket} ->
	    spawn(?MODULE, wait_connect, [LS]),
            get_request(Socket, []);
	{error, Reason} ->
	    io:format("Can't accept socket ~p~n", [Reason])
    end.

get_request(Socket, BinaryList) ->
    case gen_tcp:recv(Socket, 0, 5000) of
	{ok, Binary} ->
	    get_request(Socket, [Binary|BinaryList]);
	{error, closed} ->
	    handle(lists:reverse(BinaryList))
    end.

handle(Binary) ->
  io:format("Received ~p~n", [Binary]).

%% other requests, eg. exit message
handle_info(_Info, State) ->
    io:format("handle_info: ~p~n", [_Info]),
    {noreply, State}.

%% asynchronous requests
handle_cast(_Msg, State) ->
    io:format("handle_cast: ~p~n", [_Msg]),
    {noreply, State}.

%% synchronous requests
handle_call(_Request, _From, State) ->
    io:format("handle_call: ~p ~p~n", [_Request, _From]), 
    Reply = ok,
    {reply, Reply, State}.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
