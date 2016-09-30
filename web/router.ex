defmodule Songbox.Router do
  use Songbox.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Songbox do
    pipe_through :api
  end
end
