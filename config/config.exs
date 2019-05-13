use Mix.Config

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

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{Mix.env()}.exs"
