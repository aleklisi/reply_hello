# Build stage 0
FROM erlang:alpine

# Set working directory
RUN mkdir /buildroot
WORKDIR /buildroot

# Copy our Erlang test application
COPY ./ reply_hello

# And build the release
WORKDIR reply_hello
RUN rebar3 as prod release

# Build stage 1
FROM alpine

# Install some libs
RUN apk add --no-cache openssl && \
    apk add --no-cache ncurses-libs && \
    apk add --no-cache libstdc++

# Install the released application
COPY --from=0 /buildroot/reply_hello/_build/prod/rel/reply_hello /reply_hello

# Expose relevant ports
EXPOSE 8080
EXPOSE 8443

CMD ["/reply_hello/bin/reply_hello", "foreground"]