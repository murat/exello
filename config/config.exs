# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :exello,
  ecto_repos: [Exello.Repo]

# Configures the endpoint
config :exello, ExelloWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "wmRKTh2E56PTMhlJfxwAj0dLJwsc/S0JyLZCejBnsQacZr2Jk3Y41qtDQ3I5ANpB",
  render_errors: [view: ExelloWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Exello.PubSub,
  live_view: [signing_salt: "Md0qKxSf"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
