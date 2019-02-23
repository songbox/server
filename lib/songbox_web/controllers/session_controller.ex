defmodule SongboxWeb.SessionController do
  use Songbox.Web, :controller

  import Ecto.Query, only: [where: 2]
  import Comeonin.Bcrypt
  import Logger

  alias Songbox.User

  def create(conn, %{
    "grant_type" => "password",
    "username" => username,
    "password" => password
  }) do
    try do
      user = User
             |> where(email: ^username)
             |> Repo.one!

      cond do
        checkpw(password, user.password_hash) ->
          # Successful login
          Logger.info "User " <> username <> " just logged in"
          { :ok, jwt, _} = Guardian.encode_and_sign(user, :token)
          conn
          |> json(%{access_token: jwt})
        true ->
          # Unsuccessful login
          Logger.warn "User " <> username <> " just failed to login"
          conn
          |> put_status(401)
          |> render(SongboxWeb.ErrorView, "401.json")
      end
    rescue
      e ->
        IO.inspect e # Print error to the console for debugging
        Logger.error "Unexpected error while attempting to login user " <> username
        conn
        |> put_status(401)
        |> render(SongboxWeb.ErrorView, "401.json")
    end
  end

  def create(_conn, %{"grant_type" => "password"}) do
    throw "Credentials incomplete, provide username and password"
  end

  def create(_conn, %{"grant_type" => _}) do
    throw "Unsupported grant_type"
  end

end
