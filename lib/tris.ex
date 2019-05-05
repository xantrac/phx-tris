defmodule GameState do
  defstruct player: 'X', board: %{}, game_uuid: nil
end

defmodule Tris do
  def start_game(game_uuid) do
    %GameState{game_uuid: game_uuid}
  end

  def winning_state(['X', 'X', 'X']), do: true
  def winning_state(['O', 'O', 'O']), do: true
  def winning_state(_), do: false

  def has_winner?(state) do
    Enum.any?(
      [
        [{0, 0}, {0, 1}, {0, 2}],
        [{1, 0}, {1, 1}, {1, 2}],
        [{2, 0}, {2, 1}, {2, 2}],
        [{0, 0}, {1, 0}, {2, 0}],
        [{0, 1}, {1, 1}, {2, 1}],
        [{0, 2}, {1, 2}, {2, 2}],
        [{0, 0}, {1, 1}, {2, 2}],
        [{0, 2}, {1, 1}, {2, 0}]
      ],
      fn x ->
        Map.take(state.board, x)
        |> Map.values()
        |> winning_state
      end
    )
  end

  def game_over?(state) do
    has_winner?(state) || Map.size(state.board) == 9
  end

  def next_player('X'), do: 'O'
  def next_player('O'), do: 'X'

  def play({row, col}, state) do
    cond do
      game_over?(state) ->
        state

      {row, col} in Map.keys(state.board) ->
        state

      true ->
        %GameState{
          player: next_player(state.player),
          board: Map.put_new(state.board, {row, col}, state.player)
        }
    end
  end

  def get_game(game_uuid), do: Tris.GameSupervisor.get_game(game_uuid)

  def get_game do
    case available_game do
      {:ok, pid} -> {:ok, pid}
      _ -> new_game
    end
  end

  def available_game do
  end

  def new_game do
    new_game_uuid = UUID.uuid1()
    {:ok, pid} = Tris.GameSupervisor.get_game(new_game_uuid)
  end
end
