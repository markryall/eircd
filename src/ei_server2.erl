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
-record(state, {port, lsock}).

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
    {ok, LSock} = gen_tcp:listen(Port, [{active, true}]),
    {ok, #state{port = Port, lsock = LSock}, 0}.

handle_info({tcp, Socket, RawData}, State) ->
    io:format("handle_info: ~p~n", [RawData]),
    {noreply, State};
handle_info(timeout, #state{lsock = LSock} = State) ->
    io:format("handle_info: timeout occurred"),
    {ok, _Sock} = gen_tcp:accept(LSock),
    {noreply, State}.

handle_cast(_Msg, State) ->
    io:format("handle_cast: ~p~n", [_Msg]),
    {noreply, State}.

handle_call(_Request, _From, State) ->
    io:format("handle_call: ~p ~p~n", [_Request, _From]), 
    Reply = ok,
    {reply, Reply, State}.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
