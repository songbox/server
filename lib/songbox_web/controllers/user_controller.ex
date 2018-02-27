defmodule SongboxWeb.UserController do
  use Songbox.Web, :controller

  alias Songbox.User
  alias JaSerializer.Params

  plug :scrub_params, "data" when action in [:create, :update]

  def show_current(conn, _) do
    user = Guardian.Plug.current_resource(conn)
    render(conn, "show.json-api", data: user)
  end

  def update_current(conn, %{"data" => data = %{"type" => "user", "attributes" => _list_params}}) do
    user = Guardian.Plug.current_resource(conn)
    changeset = User.change_password_changeset(user, Params.to_attributes(data))

    case Repo.update(changeset) do
      {:ok, user} ->
        render(conn, "show.json-api", data: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

end
