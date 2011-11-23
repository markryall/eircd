%% -*- mode: Erlang; fill-column: 75; comment-column: 50; -*-

{application, eircd,
  [{description, "Erlang IRCD"},
   {vsn, "0.1.0"},
   {modules, [
	      ei_app,
	      ei_server,
	      ei_sup,
	      ei_server_sup,
	      ei_commands,
	      ei_mod_nick,
	      ei_mod_privmsg,
	      ei_mod_ping,
	      ei_mod_join,
	      ei_mod_part,
	      ei_mod_userinfo
	     ]},
   {registered, [ei_sup]},
   {applications, [kernel, stdlib]},
   {mod, {ei_app, []}}]}.
