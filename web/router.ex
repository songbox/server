defmodule Songbox.Router do
  use Songbox.Web, :router

  # Unauthenticated Requests
  pipeline :api do
    plug :accepts, ["json", "json-api"]
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
    resources "/songs", SongController, except: [:new, :edit]
  end
end
