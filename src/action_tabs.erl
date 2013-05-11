% Nitrogen Elements
% Copyright (c) Roman Shestakov (romanshestakov@yahoo.co.uk)
% See MIT-LICENSE for licensing information.

-module(action_tabs).
%% -include_lib("n2o/include/wf.hrl").
-include ("nitrogen_elements.hrl").
-compile(export_all).


-define(TABS_ELEMENT, #tabs{}).

render_action(#tab_destroy{target = Target}) ->
    wf:f("$('#~s').tabs('destroy');", [Target]);
render_action(#tab_disable{target = Target, tab = undefined}) ->
    wf:f("$('#~s').tabs('disable');", [Target]);
render_action(#tab_disable{target = Target, tab = Index}) when is_integer(Index) ->
    wf:f("$('#~s').tabs('disable', ~w);", [Target, Index]);
render_action(#tab_disable{target = Target, tab = Indexes}) when is_list(Indexes) ->
    wf:f("$('#~s').tabs(\"option\", \"disabled\", ~w);", [Target, Indexes]);
render_action(#tab_enable{target = Target}) ->
    wf:f("$(#'~s').tabs('enable');", [Target]);
render_action(#tab_remove{target = Target, tab = Index}) ->
    wf:f("(function(){var tab = $(#'~s').find(\".ui-tabs-nav li:eq(~w)\").remove();
           var panelId = tab.attr(\"aria-controls\");
           $(\"#\" + panelId).remove();
           $('#~s').tabs( \"refresh\");})();", [Target, Index, Target]);
render_action(#tab_add{target = Target, url = Url, title = Title}) ->
    wf:f("(function(){$(\"<li><a href='~s'> ~s </a></li>\").appendTo($(\"~s .ui-tabs-nav\")));
           $(#'~s').tabs( \"refresh\");})();", [Url, Title, Target, Target]);
render_action(#tab_select{target = Target, tab = Index}) ->
    wf:f("$(#'~s').tabs(\"option\", \"active\", ~w);", [Target, Index]);
render_action(#tab_option{target = Target, key = undefined, value = undefined, postback = Postback}) ->
    ExtraParam = wf:f("(function(){var opt = $(#'~s').tabs(\"option\");
                       return \"options=\" + jQuery.param(opt);})()", [Target]),
    #event{postback = Postback, delegate = ?TABS_ELEMENT#tabs.module, extra_param = ExtraParam};
render_action(#tab_option{target = Target, key = Key, value = undefined, postback = Postback}) ->
    ExtraParam = wf:f("\"~s=\"+ $('#~s').tabs(\"option\", \"~w\")", [Key, Target, Key]),
    #event{postback = Postback, delegate = ?TABS_ELEMENT#tabs.module, extra_param = ExtraParam};
render_action(#tab_event_off{target = Target, type = Type}) ->
    wf:f("$('#~s').unbind('~s');", [Target, Type]);
render_action(#tab_event_on{target = Target, type = Type, postback = Postback}) ->
    #event{target = Target, type = Type, postback = Postback, delegate = ?TABS_ELEMENT#tabs.module};
%% enable caching for ajax tabs - http://jqueryui.com/upgrade-guide/1.9/#deprecated-ajaxoptions-and-cache-options-added-beforeload-event
render_action(#tab_cache{target = Target}) ->
    wf:f("$('#~s').tabs({beforeLoad: function(event, ui){
                if(ui.tab.data(\"loaded\") ) {event.preventDefault();return;}
                ui.jqXHR.success(function() {ui.tab.data( \"loaded\", true);});}})", [Target]).
