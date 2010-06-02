-module(ei_user_tests).

-include_lib("eunit/include/eunit.hrl").

-import(ei_user, [broadcast_message/2]).

broadcast_message_empty_list_test() ->
    done = broadcast_message([], "test").
broadcast_message_non_empty_list_test() ->
    Expected = "test",
    done = broadcast_message([self(), self()], Expected),
    {send, Expected} = receive A -> A end,
    {send, Expected} = receive B -> B end.
