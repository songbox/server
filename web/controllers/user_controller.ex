defmodule Songbox.UserController do
  use Songbox.Web, :controller

  alias Songbox.User
  alias JaSerializer.Params

  plug :scrub_params, "data" when action in [:create, :update]
  plug Guardian.Plug.EnsureAuthenticated, handler: Songbox.AuthErrorHandler

  def current(conn, _) do
    user = Guardian.Plug.current_resource(conn)
    render(conn, "show.json-api", data: user)
  end

  def update(conn, %{"id" => id, "data" => data = %{"type" => "user", "attributes" => _user_params}}) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user, Params.to_attributes(data))

    case Repo.update(changeset) do
      {:ok, user} ->
        render(conn, "show.json-api", data: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(user)

    send_resp(conn, :no_content, "")
  end

end
