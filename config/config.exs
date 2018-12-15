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

config :donegood, mailgun_domain: System.get_env("MAILGUN_DOMAIN"),
                mailgun_key: System.get_env("MAILGUN_KEY")

config :ueberauth, Ueberauth,
  providers: [
    facebook: { Ueberauth.Strategy.Facebook, [] },
    twitter: { Ueberauth.Strategy.Twitter, [] },
    google: {Ueberauth.Strategy.Google, []},
    identity: { Ueberauth.Strategy.Identity, [
      callback_methods: ["POST"],
      uid_field: :username,
      nickname_field: :username,
      ] }
  ]
config :ueberauth, Ueberauth.Strategy.Facebook.OAuth,
  client_id: System.get_env("FACEBOOK_CLIENT_ID"),
  client_secret: System.get_env("FACEBOOK_CLIENT_SECRET")

config :ueberauth, Ueberauth.Strategy.Twitter.OAuth,
  consumer_key: System.get_env("TWITTER_CONSUMER_KEY"),
  consumer_secret: System.get_env("TWITTER_CONSUMER_SECRET")

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: System.get_env("GOOGLE_CLIENT_ID"),
  client_secret: System.get_env("GOOGLE_CLIENT_SECRET")


config :donegood, Donegood.Auth.Guardian,
  issuer: "donegood",
  secret_key: "D9LNECLvr/AV2B26DEZGihfTU0OyWQ9puTNVpDv79xaRdVIIdk9qHfIYg1DPHTOe"



# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
