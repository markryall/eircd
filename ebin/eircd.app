%% -*- mode: Erlang; fill-column: 75; comment-column: 50; -*-

{application, eircd,
  [{description, "Erlang IRCD"},
   {vsn, "0.1.0"},
   {modules, [ei_app, ei_server, ei_sup, ei_mnesia, ei_server_sup, ei_event, ei_rivmsg, ei_commands]},
   {registered, [ei_sup]},
   {applications, [kernel, stdlib]},
   {mod, {ei_app, []}}]}.
