defmodule Songbox.UserController do
  use Songbox.Web, :controller

  alias Songbox.User
  alias JaSerializer.Params

  plug :scrub_params, "data" when action in [:create, :update]

  def current(conn, _) do
    user = Guardian.Plug.current_resource(conn)
    render(conn, "show.json-api", data: user)
  end

end
