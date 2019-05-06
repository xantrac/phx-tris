defmodule Tris.GameHub do
  use GenServer

  def get_game do
    cond do
      available_games -> join_game
      true -> new_game
    end
  end

  defp available_games do
    GenServer.call(Tris.GameHub, :available_games)
  end

  defp join_game do
    GenServer.call(Tris.GameHub, :join_game)
  end

  defp new_game do
    GenServer.call(Tris.GameHub, :new_game)
  end

  def start_link([]), do: GenServer.start_link(__MODULE__, Map.new())
  def start_link(name: name), do: GenServer.start_link(__MODULE__, Map.new(), name: name)

  #   callbacks

  def init(games_map) do
    {:ok, games_map}
  end

  def handle_call(:available_games, _from, games_map) do
    {:reply, Enum.any?(games_map), games_map}
  end

  def handle_call(:join_game, _from, games_map) do
    {game_uuid, pid} = Enum.at(games_map, 0)
    {game, updated_game_map} = Map.pop(games_map, game_uuid)

    {:reply, {game_uuid, pid}, updated_game_map}
  end

  def handle_call(:new_game, _from, games_map) do
    game_uuid = UUID.uuid1()
    {:ok, pid} = Tris.GameSupervisor.get_game(game_uuid)
    updated_game_map = Map.put(games_map, game_uuid, pid)

    {:reply, {game_uuid, pid}, updated_game_map}
  end
end
