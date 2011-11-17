-ifndef(ei_logging).

-define(ei_logging, true).
-define(LOG(Msg), io:format("[~p,~p]: ~s~n", [?MODULE, ?LINE, Msg])).

-endif.
