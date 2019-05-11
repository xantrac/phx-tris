defmodule TrisWeb.GameView do
  use Phoenix.LiveView
  alias Tris.GameServer

  def render(assigns) do
    TrisWeb.PageView.render("index.html", assigns)
  end

  def mount(session, socket) do
    game_uuid = session.game_uuid
    game_pid = session.game_pid

    if connected?(socket), do: GameServer.subscribe(game_uuid)

    {:ok,
     assign(socket,
       game_uuid: game_uuid,
       game_pid: game_pid,
       game_state: GameServer.call(game_pid, :game_state)
     )}
  end

  def handle_event("play", move, socket) do
    game_pid = socket.assigns.game_pid
    game_state = socket.assigns.game_state

    GameServer.cast(game_pid, {:make_move, move})

    {:noreply, assign(socket, game_state: game_state)}
  end

  def handle_info({Tris.GameServer, :new_move, new_game_state}, socket) do
    {:noreply, assign(socket, game_state: new_game_state)}
  end
end
