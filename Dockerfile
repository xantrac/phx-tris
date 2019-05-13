# Build Stage
FROM elixir:1.8 AS builder
LABEL MAINTAINER=SalesLoft

ARG MIX_GITHUB_ACCESS_TOKEN

RUN apt-get update && \
  apt-get install -y curl git && \
  curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
  apt-get -y install openssl locales locales-all postgresql-client nodejs

# Install hex
RUN /usr/local/bin/mix local.hex --force && \
  /usr/local/bin/mix local.rebar --force && \
  /usr/local/bin/mix hex.info

WORKDIR /app

COPY mix.exs mix.lock ./

RUN MIX_ENV='prod' mix deps.get --only prod
RUN MIX_ENV='prod' mix deps.compile
RUN mv mix.lock mix.lock.hold

COPY assets/package.json assets/package-lock.json ./assets/
RUN cd assets && npm install

COPY assets/ assets/
RUN cd assets && npm run deploy


COPY . .
RUN mv mix.lock.hold mix.lock

RUN MIX_ENV='prod' mix phx.digest
RUN MIX_ENV='prod' mix release --env=prod

# Deploy Stage
FROM elixir:1.8-slim

WORKDIR /app

COPY --from=builder /app/releases/tris ./
COPY --from=builder /app/priv/ ./priv
COPY --from=builder /app/rel/vm.args .

ENTRYPOINT ["./bin/tris"]
CMD ["foreground"]
