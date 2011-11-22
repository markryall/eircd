-module(ei_server_SUITE).

-compile(export_all).

-include("ct.hrl").

all() -> [test1, test2].

init_per_suite(Config) ->
  ok = application:start(eircd),
  Config.

end_per_suite(Config) ->
  ok = application:stop(eircd),
  Config.

init_per_testcase(TestCase, Config) ->
  Config.

end_per_testcase(TestCase, Config) ->
  Config.

test1(Config) ->
  State = {},
  {ok, Sock} = gen_tcp:connect("127.0.0.1", 6667, [binary, {packet, 0}]),
  ok = gen_tcp:close(Sock).

test2(Config) ->
  ok.
