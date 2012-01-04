-module(ei_mod_join).

-export([init/1, handle_event/2]).

-include_lib("ei_logging.hrl").
-include_lib("ei_common.hrl").

init(_Args) -> {ok, #state{}}. 

handle_event({Pid, <<Channel/binary>>}, State) ->
    ?LOG(io_lib:format("processing join command with channel=~p", [Channel])),
    Nick = binary_to_list(State#state.nick),
    ChannelList = binary_to_list(Channel),

    Pid ! {send, ":eircd MODE " ++ ChannelList ++ " +ns\r\n"},
    Pid ! {send, ":eircd 353 " ++ Nick ++ " @ " ++ ChannelList ++ " :@" ++ Nick ++ "\r\n"},
    Pid ! {send, ":eircd 366 " ++ Nick ++ " " ++ ChannelList ++ " :End of /NAMES list.\r\n"},

    {ok, State#state{channels=lists:append(State#state.channels, ChannelList)}};
handle_event(_, State) ->
    {ok, State}.
