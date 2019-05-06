defmodule TrisWeb.GameView do
  use Phoenix.LiveView

  def render(assigns) do
    TrisWeb.PageView.render("index.html", assigns)
  end

  def mount(session, socket) do
    game_uuid = session.game_uuid
    game_pid = session.game_pid

    {:ok,
     assign(socket, game_uuid: game_uuid, game_state: Tris.GameServer.call(game_pid, :game_state))}
  end

  def handle_event("play", coordinates, socket) do
    update_game =
      String.split(coordinates, ",")
      |> Enum.map(&String.to_integer(&1))
      |> Enum.reduce({}, fn coordinate, acc -> Tuple.append(acc, coordinate) end)
      |> Tris.play(socket.assigns.game_state)

    {:noreply, assign(socket, game_state: update_game)}
  end
end
