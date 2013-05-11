%% -*- coding: utf-8 -*-

%% @copyright 2013 Roman Shestakov
%% @author Roman Shestakov <romanshestakov@yahoo.co.uk>
%% See MIT-LICENSE for licensing information.

%% @doc Nitrogen Elements
%% This is a <em>very</em> useful module. It is ...
%% @end

-module(element_tabs).

%% @headerfile "nitrogen_elements.hrl"
%% -include_lib("n2o/include/wf.hrl").
-include ("nitrogen_elements.hrl").
-compile(export_all).

reflect() -> record_info(fields, tabs).

render_element(Record) ->
    ID = Record#tabs.id,
    %% init jQuery tabs control with specified options
    Options = common:options_to_js(Record#tabs.options),
    wf:wire(wf:f("$(function(){$('#~s').tabs(~s);})", [ID, Options])),
    %% create html markup
    #panel{
	id = ID,
	body = [
	    #list{
		class = wf:to_list(Record#tabs.class),
		style = wf:to_list(Record#tabs.style),
		body = [#listitem{body = tab_link(Tab)} || Tab <- Record#tabs.tabs]
	    },
	    [#panel{
		id = Tab#tab.id,
		class = wf:to_list(Tab#tab.class),
		style = wf:to_list(Tab#tab.style),
		body = Tab#tab.body
	    } || Tab <- Record#tabs.tabs, Tab#tab.url =:= undefined]
	]
    }.

tab_link(#tab{url=undefined, id=Id, title=Title, class=Class, closable=undefined}) when is_atom(Id) ->
    #link{url="#" ++ wf:html_encode(atom_to_list(Id)), class=Class, body=[#span{text=Title}]};
tab_link(#tab{url=undefined, id=Id, title=Title, class=Class, closable=undefined}) when is_list(Id) ->
    #link{url="#" ++ wf:html_encode(Id), class=Class, body=[#span{text=Title}]};
tab_link(#tab{url=Url, id=Id, title=Title, class=Class, closable=undefined}) ->
    #link{url=Url, title=wf:html_encode(Id), class=Class, body=[#span{text=Title}]};
tab_link(#tab{closable=IsClosable, class=Class} = Tab) ->
    Class1 = case IsClosable of
	true -> Class;
	false -> Class ++ ".ui-unclosable-tab"
    end,
    tab_link(Tab#tab{class=Class1, closable=undefined}).

event(Event) ->
    %% ?PRINT({tabsevent, Event}),
    Module = wf:page_module(),
    Module:event(Event).
