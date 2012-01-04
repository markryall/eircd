-module(ei_client).

%% use gen_fsm?
-behaviour(gen_server).

-export([start_link/2]).
-export([terminate/2, init/1, handle_info/2, handle_cast/2, handle_call/3, code_change/3]).

-include_lib("ei_common.hrl").
-include_lib("ei_logging.hrl").

start_link(Name, Sock) ->
    gen_server:start_link({local, Name}, ?MODULE, [Name, Sock], []).

%% ETS or DETS for dictionary

terminate(_Reason, State) -> {noreply, State}.

init([Name, Sock]) -> {ok, #state{socket = Sock}}.

handle_info({tcp, _Socket, RawData}, State) ->
    ?LOG(io_lib:format("got message: ~p", [RawData])),
    handle(self(), binary:split(RawData, [<<"\r\n">>], [global])),
    {noreply, State};
handle_info({send, Msg}, #state{socket=Sock} = State) ->
    gen_tcp:send(Sock, Msg),
    {noreply, State};
handle_info(Msg, State) ->
    ?LOG(io_lib:format("got unknown message: ~p", [Msg])),
    {noreply, State}.
		   
%% send messages! make a function which will use handle_cast
%handle_cast({send, Msg}, #state{socket=Sock} = State) ->
%    gen_tcp:send(Sock, Msg),
%    {noreply, State};
handle_call(Msg, _From, State) -> {reply, {ok, Msg}, State}.

code_change(_OldVsn, State, _Extra) -> {ok, State}.

%% api

handle(Pid, []) ->
    ?LOG("finished processing commands");
handle(Pid, [Command|Commands]) ->
    ?LOG(io_lib:format("processing command ~p", [Command])),
    gen_event:notify(event_manager, {Pid, Command}),
    handle(Pid, Commands).

parse(Data) ->
    gen_server:cast(self(), Data).

handle_cast(stop, State) -> {stop, normal, State};
handle_cast({send, Data}, #state{socket=Sock} = State) -> gen_tcp:send(Sock, Data);
handle_cast(<<"JOIN ", Channel/binary>>, State) -> ei_mod_join:handle_event({user_join, {self(), binary_to_list(Channel)}}, State);
handle_cast(<<"PART ", Channel/binary>>, State) -> ei_mod_part:handle_event({user_part, {self(), binary_to_list(Channel)}}, State);
handle_cast(_Command, _State) ->
    {ok, _State}.

