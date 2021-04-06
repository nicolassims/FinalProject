# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :final_project,
  ecto_repos: [FinalProject.Repo]

#user locally stored (NOT IN REPO) secrets
# for Twitter APIs
#TODO: add add deploy script that inserts these as environment variables
config :extwitter, :oauth, [
  consumer_key: System.get_env("TWITTER_CONSUMER_KEY"),
  consumer_secret: System.get_env("TWITTER_CONSUMER_SECRET"),
  access_token: System.get_env("TWITTER_ACCESS_TOKEN"),
  access_token_secret: System.get_env("TWITTER_ACCESS_TOKEN_SECRET")
]

# Configures the endpoint
config :final_project, FinalProjectWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "fAsjmXjU0B8gwGIhtP2l4SS7rei4KHW0Vz959fRmkj4TWsqcwgEPF2tFUiyP2Kmb",
  render_errors: [view: FinalProjectWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: FinalProject.PubSub,
  live_view: [signing_salt: "fOBk+9Ay"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

#config :final_project,
#  mix_env: "#{Mix.env()}"
