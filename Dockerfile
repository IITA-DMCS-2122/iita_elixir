FROM elixir:latest

RUN apt-get update && \
  apt-get install -y postgresql-client

# Create app directory and copy the Elixir projects into it.
RUN mkdir /app
COPY ./todo /app
WORKDIR /app

# Install Hex package manager.
RUN mix local.hex --force
RUN mix deps.clean --all
RUN mix deps.get --force
RUN mix local.rebar --force

# Compile the project.
RUN mix do compile

CMD ["/app/entrypoint.sh"]
