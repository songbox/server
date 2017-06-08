defmodule Songbox.Router do
  use Songbox.Web, :router
  use ExAdmin.Router

  use Plug.ErrorHandler
  use Sentry.Plug

  # Unauthenticated Requests
  pipeline :api do
    plug :accepts, ["json", "json-api"]
    plug JaSerializer.Deserializer
  end

  # Authenticated Requests
  pipeline :api_auth do
    plug :accepts, ["json", "json-api"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.EnsureAuthenticated, handler: Songbox.AuthErrorHandler
    plug Guardian.Plug.LoadResource
    plug JaSerializer.ContentTypeNegotiation
    plug JaSerializer.Deserializer
  end

  scope "/api", Songbox do
    pipe_through :api

    # registration
    post "/register", RegistrationController, :create

    # login
    post "/token", SessionController, :create, as: :login
  end

  scope "/api", Songbox do
    pipe_through :api_auth

    get "/user/current", UserController, :current
    resources "/rooms", RoomController, only: [:show, :update]
    resources "/songs", SongController, except: [:new, :edit]
    resources "/lists", ListController, except: [:new, :edit]
    resources "/list-items", ListItemController, except: [:new, :edit]
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/admin", ExAdmin do
    pipe_through :browser
    admin_routes()
  end
end
