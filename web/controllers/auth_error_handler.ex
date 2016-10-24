defmodule Songbox.AuthErrorHandler do
  use Songbox.Web, :controller

  def unauthenticated(conn, _params) do
    conn
    |> put_status(401)
    |> render(Songbox.ErrorView, "401.json")
  end

  def unauthorized(conn, _params) do
    conn
    |> put_status(403)
    |> render(Songbox.ErrorView, "403.json")
  end
end
