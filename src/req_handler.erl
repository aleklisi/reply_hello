-module(req_handler).

-export([init/2]).

init(Req0, State) ->
    Qs = cowboy_req:qs(Req0),
    Query =
        #{
            <<"hub.mode">> := <<"subscribe">>,
            <<"hub.challenge">> := Challenge,
            <<"hub.verify_token">> := Token
        } = maps:from_list(uri_string:dissect_query(Qs)),

    RealToken = persistent_term:get("FACEBOOK_TOKEN"),
    Req =
        case Token == RealToken of
            false ->
                cowboy_req:reply(
                    401,
                    #{<<"content-type">> => <<"text/plain">>},
                    <<"Wrong token!">>,
                    Req0
                );
            true ->
                cowboy_req:reply(
                    200,
                    #{<<"content-type">> => <<"text/plain">>},
                    Challenge,
                    Req0
                )
        end,
    logger:error("Query = ~p\n", [Query]),
    {ok, Req, State}.
