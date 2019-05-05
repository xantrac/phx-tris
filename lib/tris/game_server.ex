defmodule Tris.GameServer do
  use GenServer

  def start_link(game_uuid) do
    IO.inspect(self())
    GenServer.start_link(__MODULE__, Tris.start_game(game_uuid), name: {:global, game_uuid})
  end

  def call(pid, request) do
    GenServer.call(pid, request)
  end

  #   callbacks

  def init(game_state) do
    {:ok, game_state}
  end

  def handle_call(:game_state, from, game_state) do
    {:reply, game_state, game_state}
  end
end
