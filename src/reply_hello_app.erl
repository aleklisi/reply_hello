%%%-------------------------------------------------------------------
%% @doc reply_hello public API
%% @end
%%%-------------------------------------------------------------------

-module(reply_hello_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    reply_hello_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
