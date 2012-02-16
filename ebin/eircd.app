%% -*- mode: Erlang; fill-column: 75; comment-column: 50; -*-

{application, eircd,
  [{description, "Erlang IRCD"},
   {vsn, "0.1.0"},
   {modules, [
	      ei_app,
	      ei_client_sup,
	      ei_client,
	      ei_server_sup,
              ei_server,
              ei_router,
              ei_db,
	      ei_mod_nick,
	      ei_mod_privmsg,
	      ei_mod_ping,
	      ei_mod_join,
	      ei_mod_part,
	      ei_mod_registration
	     ]},
   {registered, [ei_sup]},
   {applications, [kernel, stdlib]},
   {mod, {ei_app, []}}]}.
