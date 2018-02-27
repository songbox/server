defmodule SongboxWeb.Router do
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

  scope "/api", SongboxWeb do
    pipe_through :api

    # registration
    post "/register", RegistrationController, :create

    # login
    post "/token", SessionController, :create, as: :login
  end

  scope "/api", SongboxWeb do
    pipe_through :api_auth

    get "/user/current", UserController, :show_current # DEPRECATED
    get "/users/current", UserController, :show_current
    put "/users/current", UserController, :update_current
    patch "/users/current", UserController, :update_current

    resources "/rooms", RoomController, only: [:show, :update]
    resources "/songs", SongController, except: [:new, :edit]
    resources "/lists", ListController, except: [:new, :edit]
    resources "/list-items", ListItemController, except: [:new, :edit]
  end

  pipeline :browser_auth do
    plug BasicAuth, use_config: {:basic_auth, :admin_auth}
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/admin", ExAdmin do
    pipe_through :browser_auth
    admin_routes()
  end
end
