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
    Sock1 = connect(<<"user1">>),
    Sock2 = connect(<<"user2">>),

    %% join a channel 
    join(Sock1, <<"#channel1">>),
    {ok, <<":eircd 353 user1 @ #channel1 :user1\r\n">>} = gen_tcp:recv(Sock1, 37),
    {ok, <<":eircd 366 user1 #channel1 :End of /NAMES list.\r\n">>} = gen_tcp:recv(Sock1, 49),

    join(Sock2, <<"#channel1">>),
    {ok, <<":eircd 353 user2 @ #channel1 :user1 user2\r\n">>} = gen_tcp:recv(Sock2, 43),
    {ok, <<":eircd 366 user2 #channel1 :End of /NAMES list.\r\n">>} = gen_tcp:recv(Sock2, 49),

    % part a channel
    %ok = gen_tcp:send(Sock1, <<"PART #channel1\r\n">>),
    %{ok, <<":user1!a@b PART #channel1\r\n">>} = gen_tcp:recv(Sock1, 0),

    ok = gen_tcp:close(Sock1).
    %ok = gen_tcp:close(Sock2).

join(Sock, Channel) ->
  ok = gen_tcp:send(Sock, <<<<"JOIN ">>/binary, Channel/binary, <<"\r\n">>/binary>>),
    Pattern = <<<<":eircd MODE ">>/binary, Channel/binary, <<" +ns\r\n">>/binary>>,
  {ok, Pattern} = gen_tcp:recv(Sock, 27).

connect(Nick) ->
    {ok, Sock} = gen_tcp:connect(?HOST, ?PORT, ?TCP_OPTIONS),

    NewLine = <<"\r\n">>,
    ok = gen_tcp:send(Sock, <<<<"NICK ">>/binary, Nick/binary, NewLine/binary>>),
    ok = gen_tcp:send(Sock, <<"USER a b c d e\r\n">>),
    Pattern = <<<<":eircd 001 ">>/binary, Nick/binary, <<" :Welcome to the eircd Internet Relay Chat Network ">>/binary, Nick/binary, <<"\r\n">>/binary>>,
    {ok, Pattern} = gen_tcp:recv(Sock, 0),

    Sock.
