-module(ei_mod_join_SUITE).

-compile(export_all).

-include("ct.hrl").

all() -> [test1, test2].

init_per_suite(Config) ->
  Config.

end_per_suite(Config) ->
  Config.

init_per_testcase(TestCase, Config) ->
  Config.

end_per_testcase(TestCase, Config) ->
  Config.

test1(Config) ->
  State = {},
  {noreply, State} = ei_mod_join:terminate("bah", State),
  ok.

test2(Config) ->
  ok.
