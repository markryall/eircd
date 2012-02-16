-module(ei_router).

-behaviour(gen_server).

-export([start_link/0]).
-export([terminate/2, init/1, handle_info/2, handle_cast/2, handle_call/3, code_change/3]).
-export([privmsg/3, join/2, broadcast/4]).

-record(state, {channel}).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [channel], []).

init([Channel]) ->
    {ok, #state{channel = Channel}}.

handle_info(_Msg, State) ->
    {noreply, State}.

handle_call({privmsg, Pid, Target, Msg}, _From, State) ->
    {reply, {ok}, State};
handle_call({join, Pid, Channel}, _From, State) ->
    {reply, {ok}, State};
handle_call(Msg, _From, State) ->
    {reply, {ok, Msg}, State}.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

handle_cast(_Command, _State) ->
    {noreply, _State}.

terminate(_Reason, State) ->
    {noreply, State}.

privmsg(Pid, Target, Msg) ->
    gen_server:call(?MODULE, {privmsg, Pid, Target, Msg}).

join(Pid, Channel) ->
    gen_server:call(?MODULE, {join, Pid, Channel}).

broadcast(channel, Channel, Msg, Exclude) ->
    {ok, Pids} = ei_db:pids(Channel),
    F = fun(X) -> X ! {send, Msg} end,
    lists:map(F, lists:subtract(Pids, Exclude)),
    ok;
broadcast(user, Nick, Msg, Exclude=[]) ->
    ok.
