defmodule Songbox.Router do
  use Songbox.Web, :router

  pipeline :api do
    plug :accepts, ["json-api"]
    plug JaSerializer.ContentTypeNegotiation
    plug JaSerializer.Deserializer
  end

  scope "/api", Songbox do
    pipe_through :api

    # registration
    post "/register", RegistrationController, :create

    # session
    resources "/session", SessionController, only: [:index]
  end
end
