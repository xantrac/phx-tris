defmodule TrisWeb.Router do
  use TrisWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Phoenix.LiveView.Flashx
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TrisWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", TrisWeb do
  #   pipe_through :api
  # end
end
