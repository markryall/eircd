-module(ei_mod_part).

-export([init/1, handle_event/2]).

-include("ei_common.hrl").
-include("ei_logging.hrl").

init(_Args) -> {ok, #state{}}.

handle_event({Pid, <<Channel/binary>>}, State) ->
    ?LOG(io_lib:format("processing part command with channel=~p", [Channel])),
    Nick = binary_to_list(State#state.nick),
    ChannelList = binary_to_list(Channel),
    Pid ! {send, io_lib:format(":~s!~s@~s PART ~s\r\n",[Nick, State#state.username, State#state.hostname, ChannelList])},
    {ok, State#state{channels=lists:delete(State#state.channels, ChannelList)}};
handle_event(_, State) ->
    {ok, State}.
