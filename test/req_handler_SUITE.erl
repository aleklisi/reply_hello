-module(req_handler_SUITE).

-include_lib("common_test/include/ct.hrl").

-compile(export_all).

suite() ->
    [{timetrap, {minutes, 1}}].

init_per_suite(Config) ->
    {ok, _} = application:ensure_all_started(hackney),
    {ok, _} = application:ensure_all_started(reply_hello),
    Config.

end_per_suite(_Config) ->
    ok = application:stop(reply_hello),
    ok.
init_per_testcase(_Case, Config) ->
    Config.

end_per_testcase(_Case, _Config) ->
    ok.
all() ->
    [
        verification_request_works_with_correct_token,
        verification_request_fails_with_incorrect_token
    ].

%%--------------------------------------------------------------------
%% TEST CASES
%%--------------------------------------------------------------------

verification_request_works_with_correct_token(_Config) ->
    Url =
        "http://localhost:8080/webhooks?hub.mode=subscribe&hub.challenge=1158201444&hub.verify_token=fb_token_value",
    {ok, 200, _RespHeaders, ClientRef} = hackney:request(get, Url, [], [], []),
    {ok, <<"1158201444">>} = hackney:body(ClientRef),
    ok.

verification_request_fails_with_incorrect_token(_Config) ->
    Url =
        "http://localhost:8080/webhooks?hub.mode=subscribe&hub.challenge=1158201444&hub.verify_token=wrong_token_value",
    {ok, 401, _RespHeaders, ClientRef} = hackney:request(get, Url, [], [], []),
    {ok, <<"Wrong token!">>} = hackney:body(ClientRef),
    ok.
