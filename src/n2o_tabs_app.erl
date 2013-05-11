% Nitrogen Elements Examples
% Copyright (c) 2013 Roman Shestakov (romanshestakov@yahoo.co.uk)
% See MIT-LICENSE for licensing information.

-module(n2o_tabs_app).
-behaviour(application).
-export([
	 start/0,
	 start/2,
	 stop/1
	]).

-define(APPS, [sync, crypto, ranch, cowboy, n2o_tabs]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

%% to start manually from console with start.sh
start() ->
    [begin application:start(A), io:format("~p~n", [A]) end || A <- ?APPS].

start(_StartType, _StartArgs) ->
    n2o_tabs_sup:start_link().

stop(_State) ->
    ok.
