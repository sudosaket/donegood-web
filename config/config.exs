# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :donegood,
  ecto_repos: [Donegood.Repo]

# Configures the endpoint
config :donegood, DonegoodWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "aM4gNiM/rI/c1NRIwvw6vhHigmLlUlgqN0yYpjNLOFsDxfggBrcmaqMSBXior4eG",
  render_errors: [view: DonegoodWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Donegood.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
