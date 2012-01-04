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

  %% user registration 
  ok = gen_tcp:send(Sock, <<"NICK user2\r\n">>),
  ok = gen_tcp:send(Sock, <<"USER a b c d e\r\n">>),
  {ok, <<":eircd 001 user2 :Welcome to the eircd Internet Relay Chat Network user2\r\n">>} = gen_tcp:recv(Sock, 0),

  %% join a channel 
  ok = gen_tcp:send(Sock, <<"JOIN #channel1\r\n">>),
  {ok, <<":eircd MODE #channel1 +ns\r\n">>} = gen_tcp:recv(Sock, 27),
%%  {ok, <<":eircd 353 user2 @ #channel1 :@user2\r\n">>} = gen_tcp:recv(Sock, 38),
%%  {ok, <<":eircd 366 user2 #channel1 :End of /NAMES list.\r\n">>} = gen_tcp:recv(Sock, 49),

  % part a channel
%%  ok = gen_tcp:send(Sock, <<"PART #channel1\r\n">>),
%%  {ok, <<":user2!a@b PART #channel1\r\n">>} = gen_tcp:recv(Sock, 0),

  % PING
%%  ok = gen_tcp:send(Sock, <<"PING\r\n">>),
%%  {ok, <<"PONG\r\n">>} = gen_tcp:recv(Sock, 0),

  ok = gen_tcp:close(Sock).

