defmodule Songbox.ListItemController do
  use Songbox.Web, :controller

  alias Songbox.ListItem
  alias JaSerializer.Params

  plug :scrub_params, "data" when action in [:create, :update]

  def index(conn, _params) do
    list_items = Repo.all(ListItem)
    render(conn, "index.json-api", data: list_items)
  end

  def create(conn, %{"data" => data = %{"type" => "list-item", "attributes" => _list_item_params}}) do
    list_item = %ListItem{user_id: Guardian.Plug.current_resource(conn).id}
    changeset = ListItem.changeset(list_item, Params.to_attributes(data))

    case Repo.insert(changeset) do
      {:ok, list_item} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", list_item_path(conn, :show, list_item))
        |> render("show.json-api", data: list_item)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    list_item = current_user_list_item(conn, id)
    render(conn, "show.json-api", data: list_item)
  end

  def update(conn, %{"id" => id, "data" => data = %{"type" => "list-item", "attributes" => _list_item_params}}) do
    list_item = current_user_list_item(conn, id)
    changeset = ListItem.changeset(list_item, Params.to_attributes(data))

    case Repo.update(changeset) do
      {:ok, list_item} ->
        render(conn, "show.json-api", data: list_item)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    list_item = current_user_list_item(conn, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(list_item)

    send_resp(conn, :no_content, "")
  end

  defp current_user_list_item(conn, id) do
    current_user = Guardian.Plug.current_resource(conn)

    ListItem
    |> where(user_id: ^current_user.id, id: ^id)
    |> Repo.one!
  end

end
