FROM library/elixir:1.3.4

EXPOSE 4000
WORKDIR /app

# init hex
RUN mix local.hex --force

# add dependencies
ADD mix.* /app/
RUN mix deps.get

# add app
ADD . /app
RUN mix compile

CMD trap exit TERM; mix phoenix.server & wait
