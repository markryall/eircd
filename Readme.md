eircd
===

This is an ircd implemented in erlang entirely for the purpose of learning erlang.

Basic usage
---

	git clone git@github.com:markryall/eircd.git
	cd eircd/ebin
	erlc ../src/*.erl
	erl
	application:start(eircd).
	# have an amazing irc experience*
	application:stop(eircd).'

Starting up (requires ruby, rake and sinan)
---

Open a separate console and run:

     cd _build/development/apps/eircd-0.1.0/ebin
     screen -S eircd

In your own console

	rake start

To shutdown the server

	rake stop
