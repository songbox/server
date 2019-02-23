use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or you later on).
config :songbox, SongboxWeb.Endpoint,
  secret_key_base: System.get_env("SECRET_KEY_BASE")

# Configures authentication
config :guardian, Guardian,
  secret_key: System.get_env("GUARDIAN_SECRET")

# Configure your database
config :songbox, Songbox.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "16") # heroku's limit is 20 for 'hobby dev'

# Configure Sentry
config :sentry,
  dsn: System.get_env("SENTRY_DSN")

