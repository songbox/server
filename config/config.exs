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
config :songbox, SongboxWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "JDjBUeE6jtPrATQVZivmZSg6YAxy3akn2U9oi5Z9HoimJSD2n9FySiRKm5MQo84l",
  render_errors: [view: SongboxWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Songbox.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures authentication
config :guardian, Guardian,
  allowed_algos: ["HS512"], # optional
  verify_module: Guardian.JWT,  # optional
  issuer: "Songbox",
  ttl: { 30, :days },
  verify_issuer: true, # optional
  secret_key: "MHYI1P5y5cwpukEsOguYySh2fvkf/twdm3HKIF4bVXqmUk6TVsKQAwhnXIfsAQcs",
  serializer: Songbox.GuardianSerializer

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure Sentry
config :sentry,
  dsn: "https://public:secret@app.getsentry.com/1",
  included_environments: [:prod],
  environment_name: Mix.env,
  use_error_logger: true

config :ex_admin,
  repo: Songbox.Repo,
  module: Songbox,    # Songbox.Web for phoenix >= 1.3.0-rc
  modules: [
    Songbox.ExAdmin.Dashboard,
    Songbox.ExAdmin.User,
    Songbox.ExAdmin.Room,
    Songbox.ExAdmin.Song,
  ]

config :basic_auth, :admin_auth, [
  username: {:system, "ADMIN_USERNAME"},
  password: {:system, "ADMIN_PASSWORD"},
  realm: "Songbox Admin"
]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"


config :xain, :after_callback, {Phoenix.HTML, :raw}

