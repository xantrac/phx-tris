defmodule Tris.GameServer do
  use GenServer

  @topic inspect(__MODULE__)

  def start_link(game_uuid) do
    GenServer.start_link(__MODULE__, Tris.start_game(game_uuid), name: {:global, game_uuid})
  end

  def call(pid, request), do: GenServer.call(pid, request)
  def cast(pid, request), do: GenServer.cast(pid, request)

  #   callbacks

  def init(game_state), do: {:ok, game_state}

  def handle_call(:game_state, _from, game_state) do
    {:reply, game_state, game_state}
  end

  def handle_cast({:make_move, move}, game_state) do
    new_game_state =
      String.split(move, ",")
      |> Enum.map(&String.to_integer(&1))
      |> Enum.reduce({}, fn coordinate, acc -> Tuple.append(acc, coordinate) end)
      |> Tris.play(game_state)

    notify_move(new_game_state)

    {:noreply, new_game_state}
  end

  def subscribe(game_uuid) do
    Phoenix.PubSub.subscribe(Tris.PubSub, @topic <> "#{game_uuid}")
  end

  defp notify_move(new_game_state) do
    Phoenix.PubSub.broadcast(
      Tris.PubSub,
      @topic <> "#{new_game_state.game_uuid}",
      {__MODULE__, :new_move, new_game_state}
    )
  end
end
