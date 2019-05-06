defmodule Tris.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

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
