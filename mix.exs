defmodule Songbox.Mixfile do
  use Mix.Project

  def project do
    [
      app: :songbox,
      version: "0.0.1",
      elixir: "~> 1.2",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Songbox, []},
      applications: [
        :phoenix,
        :phoenix_pubsub,
        :phoenix_html,
        :cowboy,
        :sentry,
        :logger,
        :gettext,
        :phoenix_ecto,
        :postgrex,
        :comeonin
      ]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.3.0"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.2"},
      {:postgrex, ">= 0.0.0"},
      {:gettext, "~> 0.13.1"},
      {:cowboy, "~> 1.0"},
      # api dependencies
      {:cors_plug, "~> 1.1"},
      {:comeonin, "~> 2.5"},
      {:guardian, "~> 0.14.0"},
      {:ja_serializer, "~> 0.12.0"},
      {:ecto_ordered, "~> 0.2.0-beta1"},
      # admin
      {:ex_admin, github: "smpallen99/ex_admin"},
      {:basic_auth, "~> 2.0.0"},
      # dev/test dependencies
      {:mix_test_watch, "~> 0.2.6", only: :dev},
      {:ex_unit_notifier, "~> 0.1", only: :test},
      {:credo, "~> 0.6.0", only: :dev},
      {:junit_formatter, ">= 0.0.0"},
      #
      {:sentry, "~> 2.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "start": ["phoenix.server"],
      "test": ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
