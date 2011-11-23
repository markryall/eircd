-module(ei_mod_part).

-export([
	 handle_event/2
	 ]).

-include("ei_common.hrl").

handle_event({user_part, {Pid, Channel}}, State) ->
    io:format("~p: processing part command with channel=~p~n", [?MODULE, Channel]),
    Nick = State#state.nick,
    Pid ! {send, io_lib:format(":~s!~s@~s PART ~s\r\n",[Nick, State#state.username, State#state.hostname, Channel])},
    {ok, State#state{channels=lists:delete(State#state.channels, Channel)}};
handle_event(_, State) ->
    {ok, State}.
