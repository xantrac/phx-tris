defmodule TrisWeb.PageController do
  use TrisWeb, :controller
  alias Phoenix.LiveView

  def index(conn, _params) do
    {game_uuid, game_pid} = Tris.GameHub.get_game()

    LiveView.Controller.live_render(conn, TrisWeb.GameView,
      session: %{game_pid: game_pid, game_uuid: game_uuid}
    )
  end
end
