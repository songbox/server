defmodule SongboxWeb.AuthErrorHandler do
  use Songbox.Web, :controller

  def unauthenticated(conn, _params) do
    conn
    |> put_status(401)
    |> render(SongboxWeb.ErrorView, "401.json")
  end

  def unauthorized(conn, _params) do
    conn
    |> put_status(403)
    |> render(SongboxWeb.ErrorView, "403.json")
  end
end
