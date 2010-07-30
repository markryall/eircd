-module(ei_mod_userinfo).

-behaviour(gen_event).

-export([
	 init/1,
	 add_handler/0,
	 delete_handler/0
	 ]).
-export([
	 handle_event/2,
	 handle_call/2,
	 handle_info/2,
	 code_change/3,
	 terminate/2
	 ]).

-include_lib("ei_logging.hrl").

-record(state, {}).

init([]) ->
    {ok, #state{}}.

add_handler() ->
    ei_event:add_handler(?MODULE, []).

delete_handler() ->
    ei_event:delete_handler(?MODULE, []).

terminate(_Reason, State) ->
    {noreply, State}.

handle_call(Msg, State) ->
    {reply, {ok, Msg}, State}.

handle_info(_, State) ->
    {noreply, State}.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

handle_event({user_userinfo_registration, {Pid, Username, Hostname, Servername, Realname}}, State) ->
    ?LOG("processing userinfo registration event"),
    Nick = ei_user:get_nick(Pid),
    ei_user:store_userinfo(Pid, Username, Hostname, Servername, Realname),
    Pid ! {send, io_lib:format(":eircd 001 ~s :Welcome to the eircd Internet Relay Chat Network ~s\r\n", [Nick, Nick])},
    {ok, State};
handle_event(_, State) ->
    {ok, State}.
