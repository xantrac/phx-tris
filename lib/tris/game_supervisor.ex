defmodule Tris.GameSupervisor do
  use DynamicSupervisor

  def get_game(game_uuid) do
    case DynamicSupervisor.start_child(__MODULE__, %{
           id: Tris.GameServer,
           start: {Tris.GameServer, :start_link, [game_uuid]}
         }) do
      {:ok, pid} -> {:ok, pid}
      {:error, {:already_started, pid}} -> {:ok, pid}
      err -> {:error, err}
    end
  end

  def start_link(name: name), do: DynamicSupervisor.start_link(__MODULE__, [], name: name)
  def start_link([]), do: DynamicSupervisor.start_link(__MODULE__, [])

  def init(_arg), do: DynamicSupervisor.init(strategy: :one_for_one)
end
