-module(ei_db).

-behaviour(gen_server).

-export([start_link/0]).
-export([terminate/2, init/1, handle_info/2, handle_cast/2, handle_call/3, code_change/3]).
-export([lookup/2, join/2, part/2, user_registration/2]).

-record(state, {nick, channel}).

start_link() ->
    Nick = gb_trees:empty(),
    Channel = gb_trees:empty(),
    gen_server:start_link({local, ?MODULE}, ?MODULE, [Nick, Channel], []).

handle_info(_Msg, State) ->
    {noreply, State}.

handle_call({join, Pid, Channel}, _From, #state{nick = NickTree, channel = ChannelTree} = State) ->
    NewPids = [Pid] ++ channel_users(ChannelTree, Channel),
    T = update_channel_users(ChannelTree, Channel, NewPids),
    F = fun(X) -> lookup(NickTree, X) end,
    Nicks = lists:sort(lists:map(F, NewPids)),
    {reply, {ok, Nicks}, State#state{channel = T}};
handle_call({part, Pid}, _From, State) ->
    {reply, {ok}, State};
handle_call({nick, Pid}, _From, State) ->
    {reply, {ok}, State};
handle_call({user_registration, Pid, Nick}, _From, #state{nick = NickTree} = State) ->
    T = gb_trees:insert(Pid, Nick, NickTree),
    {reply, {ok}, State#state{nick = T}};
handle_call(Msg, _From, State) ->
    {reply, {ok, Msg}, State}.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

handle_cast(_Command, _State) ->
    {noreply, _State}.

terminate(_Reason, State) ->
    {noreply, State}.

init([Nick, Channel]) ->
    {ok, #state{nick = Nick, channel = Channel}}.

update_channel_users(Tree, Channel, Pids) ->
    case gb_trees:is_defined(Channel, Tree) of
        true -> gb_trees:update(Channel, Pids, Tree);
        false -> gb_trees:insert(Channel, Pids, Tree)
    end.

channel_users(Tree, Channel) ->
    case gb_trees:lookup(Channel, Tree) of
        {value, P} -> P;
        none -> []
    end.

lookup(Tree, Pid) ->
    {value, Val} = gb_trees:lookup(Pid, Tree),
    Val.

join(Channel, Pid) ->
    gen_server:call(?MODULE, {join, Pid, Channel}).

part(Channel, Pid) ->
    gen_server:call(?MODULE, {part, Pid, Channel}).

nick(Pid, Nick) ->
    gen_server:call(?MODULE, {nick, Pid, Nick}).

user_registration(Pid, Nick) ->
    gen_server:call(?MODULE, {user_registration, Pid, Nick}).
