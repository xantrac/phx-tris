# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :tris, TrisWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "yTGaPxynELBcG9GlHoCVHSFb6Of8ftZlM47tHMAPnIETslHawsLAciQzNNIIgrIH",
  render_errors: [view: TrisWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Tris.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [
    signing_salt: "WocWVwnJIOk5egPoF2+2pizpDj1z0yFUqfOSKbxSYWBMFsGVFOB5IKjUHebgBf6q"
  ]

config :phoenix,
  template_engines: [leex: Phoenix.LiveView.Engine]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.

import_config "#{Mix.env()}.exs"
