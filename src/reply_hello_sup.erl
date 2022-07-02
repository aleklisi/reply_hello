%%%-------------------------------------------------------------------
%% @doc reply_hello top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(reply_hello_sup).

-behaviour(supervisor).

-export([start_link/0]).

-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

init([]) ->
    SupFlags = #{
        strategy => one_for_all,
        intensity => 0,
        period => 1
    },
    ChildSpecs = [],

    %% setting up cowboy requests handler
    Dispatch = cowboy_router:compile([
        {'_', [{"/webhooks", req_handler, []}]}
    ]),
    {ok, _} = cowboy:start_clear(
        my_http_listener,
        [{port, 8080}],
        #{env => #{dispatch => Dispatch}}
    ),

    %% Get env
    get_env(),
    {ok, {SupFlags, ChildSpecs}}.

get_env() ->
    case os:getenv("FACEBOOK_TOKEN") of
        false ->
            error("FACEBOOK_TOKEN env is not set!");
        Token ->
            BinaryToken = list_to_binary(Token),
            persistent_term:put("FACEBOOK_TOKEN", BinaryToken)
    end.
