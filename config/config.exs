# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :songbox,
  ecto_repos: [Songbox.Repo]

# Configures json-api
config :phoenix, :format_encoders,
  "json-api": Poison

config :phoenix, PhoenixExample.Endpoint,
  render_errors: [view: PhoenixExample.ErrorView, accepts: ~w(html json json-api)]

config :mime, :types, %{
  "application/vnd.api+json" => ["json-api"]
}

# Configures the endpoint
config :songbox, Songbox.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "JDjBUeE6jtPrATQVZivmZSg6YAxy3akn2U9oi5Z9HoimJSD2n9FySiRKm5MQo84l",
  render_errors: [view: Songbox.ErrorView, accepts: ~w(json)],
  pubsub: [name: Songbox.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

