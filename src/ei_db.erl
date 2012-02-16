-module(ei_db).

-behaviour(gen_server).

-export([start_link/0]).
-export([terminate/2, init/1, handle_info/2, handle_cast/2, handle_call/3, code_change/3]).
-export([lookup/2, join/2, part/2, user_registration/2, nick/2, users/1, pids/1]).

-record(state, {nick, channel}).

start_link() ->
    Nick = gb_trees:empty(),
    Channel = gb_trees:empty(),
    gen_server:start_link({local, ?MODULE}, ?MODULE, [Nick, Channel], []).

handle_info(_Msg, State) ->
    {noreply, State}.

handle_call({join, Pid, Channel}, _From, #state{nick = NickTree, channel = ChannelTree} = State) ->
    NewPids = [Pid] ++ pids(ChannelTree, Channel),
    T = update_tree(ChannelTree, Channel, NewPids),
    Nicks = nicks(NickTree, NewPids),
    {reply, {ok, Nicks}, State#state{channel = T}};
handle_call({part, _Pid}, _From, State) ->
    {reply, {ok}, State};
handle_call({nick, _Pid}, _From, State) ->
    {reply, {ok}, State};
handle_call({user_registration, Pid, Nick}, _From, #state{nick = NickTree} = State) ->
    T = gb_trees:insert(Pid, Nick, NickTree),
    {reply, {ok}, State#state{nick = T}};
handle_call({users, Channel}, _From, #state{nick = NickTree, channel = ChannelTree} = State) ->
    Nicks = nicks(NickTree, pids(ChannelTree, Channel)),
    {reply, {ok, Nicks}, State};
handle_call({pids, Channel}, _From, #state{nick = NickTree, channel = ChannelTree} = State) ->
    {reply, {ok, pids(ChannelTree, Channel)}, State};
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

nicks(NickTree, Pids) ->
    F = fun(X) -> lookup(NickTree, X) end,
    lists:sort(lists:map(F, Pids)).

update_tree(Tree, Key, Value) ->
    case gb_trees:is_defined(Key, Tree) of
        true -> gb_trees:update(Key, Value, Tree);
        false -> gb_trees:insert(Key, Value, Tree)
    end.

pids(Tree, Channel) ->
    case gb_trees:lookup(Channel, Tree) of
        {value, P} -> P;
        none -> []
    end.

lookup(Tree, Key) ->
    {value, Val} = gb_trees:lookup(Key, Tree),
    Val.

join(Channel, Pid) ->
    gen_server:call(?MODULE, {join, Pid, Channel}).

part(Channel, Pid) ->
    gen_server:call(?MODULE, {part, Pid, Channel}).

nick(Pid, Nick) ->
    gen_server:call(?MODULE, {nick, Pid, Nick}).

users(Channel) ->
    gen_server:call(?MODULE, {users, Channel}).

pids(Channel) ->
    gen_server:call(?MODULE, {pids, Channel}).

user_registration(Pid, Nick) ->
    gen_server:call(?MODULE, {user_registration, Pid, Nick}).

