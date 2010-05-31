-module(ei_user_tests).

-include_lib("eunit/include/eunit.hrl").

-import(ei_user, [broadcast_message/2]).

broadcast_message_test() ->
    broadcast_message([self()], "test").
