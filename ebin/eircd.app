%% -*- mode: Erlang; fill-column: 75; comment-column: 50; -*-

{application, eircd,
  [{description, "Erlang IRCD"},
   {vsn, "0.1.0"},
   {modules, [ei_app, ei_server, ei_sup, ei_app_tests]},
   {registered, [ei_sup]},
   {applications, [kernel, stdlib]},
   {mod, {ei_app, []}}]}.