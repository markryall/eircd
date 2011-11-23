-ifndef(ei_common).

-define(ei_common, true).
-record(state, {lsock, socket, nick, channels=[], username, hostname, servername, realname}).

-endif.
