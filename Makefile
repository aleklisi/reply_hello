shell:
	FACEBOOK_TOKEN="fb_token_value" rebar3 shell

run_tests:
	FACEBOOK_TOKEN="fb_token_value" rebar3 ct

format:
	rebar3 fmt

build_docker:
	docker build -t erlang_reply_hello .

run_docker:
	docker run -d -p 8080:8080 --name erlang_reply_hello -e FACEBOOK_TOKEN="fb_token_value" erlang_reply_hello

stop_docker:
	docker stop erlang_reply_hello

build_and_run_docker: build_docker run_docker
