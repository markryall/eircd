-module(ei_server_SUITE).

-compile(export_all).

-include("ct.hrl").

-define(HOST, "127.0.0.1").
-define(PORT, 6667).
-define(TCP_OPTIONS, [binary, {packet, 0}, {active, false}]).

all() -> [test_registration].

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

test_registration(Config) ->
  {ok, Sock} = gen_tcp:connect(?HOST, ?PORT, ?TCP_OPTIONS),
  ok = gen_tcp:send(Sock, "NICK tom\r\n"),
  ok = gen_tcp:send(Sock, "USER a b c d e\r\n"),
  {ok, <<":eircd 001 tom :Welcome to the eircd Internet Relay Chat Network tom\r\n">>} = gen_tcp:recv(Sock, 0),
  ok = gen_tcp:close(Sock).

