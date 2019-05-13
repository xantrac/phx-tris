defmodule Tris.Application do
  use Application

  def start(_type, _args) do
    children = [
      TrisWeb.Endpoint,
      {Tris.GameSupervisor, name: Tris.GameSupervisor},
      {Tris.GameHub, name: Tris.GameHub}
    ]

    opts = [strategy: :one_for_one, name: Tris.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    TrisWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
