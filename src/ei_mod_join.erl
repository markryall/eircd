-module(ei_mod_join).

-export([
	 handle_event/2
	 ]).

-include_lib("ei_logging.hrl").
-include_lib("ei_common.hrl").

handle_event({user_join, {Pid, Channel}}, State) ->
    ?LOG(io_lib:format("processing join command with channel=~p", [Channel])),
    Nick = State#state.nick,

    Pid ! {send, ":eircd MODE " ++ Channel ++ " +ns\r\n"},
    Pid ! {send, ":eircd 353 " ++ Nick ++ " @ " ++ Channel ++ " :@" ++ Nick ++ "\r\n"},
    Pid ! {send, ":eircd 366 " ++ Nick ++ " " ++ Channel ++ " :End of /NAMES list.\r\n"},

    {ok, State#state{channels=lists:append(State#state.channels, Channel)}};
handle_event(_, State) ->
    {ok, State}.
