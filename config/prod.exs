use Mix.Config

config :tris, TrisWeb.Endpoint,
  http: [:inet6, port: System.get_env("PORT") || 80],
  url: [host: System.get_env("HOST"), port: 80],
  server: true,
  cache_static_manifest: "priv/static/manifest.json",
  root: "."

config :logger, level: :info
