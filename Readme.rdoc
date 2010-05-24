eircd
=====

This is an ircd implemented in erlang entirely for the purpose of learning erlang.

`
git clone git@github.com:markryall/eircd.git
cd eircd/ebin
erlc ../src/*.erl
erl
application:start(eircd).
# have an amazing irc experience*
application:stop(eircd).
`

Note that 'amazing irc experience' at this stage translates to establishing a telnet connection, typing some stuff then disconnecting the connection

You will then be astounded to discover that the server will have dumped what you typed to the screen.

To the screen I tell you!

See it to believe it.