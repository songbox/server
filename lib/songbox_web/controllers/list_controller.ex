defmodule SongboxWeb.ListController do
  use Songbox.Web, :controller

  alias Songbox.List
  alias JaSerializer.Params

  plug :scrub_params, "data" when action in [:create, :update]

  def index(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)

    lists = List
            |> where(user_id: ^current_user.id)
            |> Repo.all

    render(conn, "index.json-api", data: lists)
  end

  def create(conn, %{"data" => data = %{"type" => "list", "attributes" => _list_params}}) do
    list = %List{user_id: Guardian.Plug.current_resource(conn).id}
    changeset = List.changeset(list, Params.to_attributes(data))

    case Repo.insert(changeset) do
      {:ok, list} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", list_path(conn, :show, list))
        |> render("show.json-api", data: list)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    list = current_user_list(conn, id)
    render(conn, "show.json-api", data: list)
  end

  def update(conn, %{"id" => id, "data" => data = %{"type" => "list", "attributes" => _list_params}}) do
    list = current_user_list(conn, id)
    changeset = List.changeset(list, Params.to_attributes(data))

    case Repo.update(changeset) do
      {:ok, list} ->
        render(conn, "show.json-api", data: list)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    list = current_user_list(conn, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(list)

    send_resp(conn, :no_content, "")
  end

  defp current_user_list(conn, id) do
    current_user = Guardian.Plug.current_resource(conn)

    List
    |> where(user_id: ^current_user.id, id: ^id)
    |> Repo.one!
  end
end
