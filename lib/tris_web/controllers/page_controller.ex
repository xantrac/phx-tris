defmodule TrisWeb.PageController do
  use TrisWeb, :controller
  alias Phoenix.LiveView

  def index(conn, _params) do
    {:ok, game_pid} = Tris.get_game()
    LiveView.Controller.live_render(conn, TrisWeb.GameView, session: %{game_pid: game_pid})
  end
end
