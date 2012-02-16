-module(ei_client).

%% use gen_fsm?
-behaviour(gen_server).

-export([start_link/2]).
-export([terminate/2, init/1, handle_info/2, handle_cast/2, handle_call/3, code_change/3]).

-include_lib("ei_common.hrl").
-include_lib("ei_logging.hrl").

start_link(Name, Sock) ->
    gen_server:start_link({local, Name}, ?MODULE, [Name, Sock], []).

terminate(_Reason, State) -> {noreply, State}.

init([_Name, Sock]) -> {ok, #state{socket = Sock}}.

handle_info({tcp, _Socket, RawData}, State) ->
    ?LOG(io_lib:format("got message: ~p", [RawData])),
    handle(self(), binary:split(RawData, [<<"\r\n">>], [global])),
    {noreply, State};
handle_info({send, Msg}, #state{socket=Sock} = State) ->
    ?LOG(io_lib:format("got message: {send, ~p}", [Msg])),
    gen_tcp:send(Sock, Msg),
    {noreply, State};
handle_info(Msg, State) ->
    ?LOG(io_lib:format("got unknown message: ~p", [Msg])),
    {noreply, State}.
		   
handle_call(Msg, _From, State) -> {reply, {ok, Msg}, State}.

code_change(_OldVsn, State, _Extra) -> {ok, State}.

%% api

handle(_Pid, []) ->
    ?LOG("finished processing commands");
handle(Pid, [Command|Commands]) ->
    ?LOG(io_lib:format("processing command ~p", [Command])),
    gen_server:cast(self(), Command),
    handle(Pid, Commands).

handle_cast(stop, State) -> {stop, normal, State};
handle_cast(<<"NICK ", Nick/binary>>, State) ->
    {ok, NewState} = ei_mod_registration:handle_event({nick, {self(), Nick}}, State),
    {noreply, NewState};
handle_cast(<<"USER ", Arguments/binary>>, State) ->
    {ok, NewState} = ei_mod_registration:handle_event({user, {self(), Arguments}}, State),
    {noreply, NewState};
handle_cast(<<"JOIN ", Channel/binary>>, State) ->
    {ok, NewState} = ei_mod_join:handle_event({self(), Channel}, State),
    {noreply, NewState};
handle_cast(<<"PART ", Channel/binary>>, State) ->
    {ok, NewState} = ei_mod_part:handle_event({self(), Channel}, State),
    {noreply, NewState};
handle_cast(_Command, _State) ->
    ?LOG(io_lib:format("ignoring command ~p", [_Command])),
    {noreply, _State}.

