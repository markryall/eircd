-module(ei_app_tests).

-include_lib("eunit/include/eunit.hrl").

ei_server_test_() -> 
	[?_assert(ei_server:terminate(reason, state) =:= {noreply, state})].