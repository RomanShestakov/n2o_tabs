% Copyright (c) 2013 Roman Shestakov (romanshestakov@yahoo.co.uk)
% See MIT-LICENSE for licensing information.

-module(n2o_tabs_sup).
-behaviour(supervisor).
-export([
	 start_link/0,
	 init/1
	]).

-compile(export_all).
-include_lib ("n2o/include/wf.hrl").
-define(APP, n2o_tabs).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
    {ok, _} = cowboy:start_http(http, 100,
				[{port, 8000}],
				[{env, [{dispatch, dispatch_rules()}]}]),
    {ok, {{one_for_one, 5, 10}, []}}.

dispatch_rules() ->
    cowboy_router:compile(
	%% {Host, list({Path, Handler, Opts})}
	[{'_', [
	    {["/content/[...]"], cowboy_static, [{directory, {priv_dir, ?APP, [<<"content">>]}},
		{mimetypes, {fun mimetypes:path_to_mimes/2, default}}]},
	    {["/static/[...]"], cowboy_static, [{directory, {priv_dir, ?APP, [<<"static">>]}},
		{mimetypes, {fun mimetypes:path_to_mimes/2, default}}]},
	    {["/websocket/[...]"], n2o_websocket, []},
	    {'_', n2o_cowboy, []}
    ]}]).
