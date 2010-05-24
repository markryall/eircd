-module(ei_server).

-behaviour(gen_server).

-export([
	 start_link/1,
	 start_link/0,
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

%% need to do something with the LSock variable rather than throw it away
init([Port]) ->
    {ok, LSock} = gen_tcp:listen(Port, [{active, true}]),
    {ok, #state{}}.

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
