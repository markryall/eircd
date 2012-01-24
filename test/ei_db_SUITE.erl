-module(ei_db_SUITE).

-compile(export_all).

-include("ct.hrl").

all() -> [test_user_registration, test_join].

init_per_suite(Config) ->
    Config.

end_per_suite(Config) ->
    Config.

init_per_testcase(TestCase, Config) ->
    Config.

end_per_testcase(TestCase, Config) ->
    Config.

test_user_registration(Config) ->
    Pid = 1,
    Nick = "user1",
    State = {state, gb_trees:empty(), undefined},
    From = undefined,
    {reply, {ok}, {state, NickTree, undefined}} = ei_db:handle_call({user_registration, Pid, Nick}, From, State),

    {value, Nick} = gb_trees:lookup(Pid, NickTree).

test_join(Config) ->
    Pid = 1,
    Nick = "user1",
    Channel = "#abc",
    NickTree = tree(gb_trees:empty(), [{Pid, Nick}]),
    ChannelTree = tree(gb_trees:empty(), [{Channel, [Pid]}]),
    State = {state, NickTree, gb_trees:empty()},
    From = undefined,
    {reply, {ok, [Nick]}, {state, NickTree, ChannelTree}} = ei_db:handle_call({join, Pid, Channel}, From, State).

tree(Tree, []) ->
    Tree;
tree(Tree, [H|T]) ->
    {Key, Value} = H,
    tree(gb_trees:insert(Key, Value, gb_trees:empty()), T).

