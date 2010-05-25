-module(ei_app_tests).

-include_lib("eunit/include/eunit.hrl").

reverse_test_() -> 
	[?_assert(lists:reverse([1,2,3]) =:= [3,2,1])].

length_test()  ->  3 = length("cat").