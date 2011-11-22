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

