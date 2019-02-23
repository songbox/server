defmodule SongboxWeb.RoomController do
  use Songbox.Web, :controller

  alias Songbox.Room
  alias JaSerializer.Params

  plug :scrub_params, "data" when action in [:update]

  def show(conn, %{"id" => id}) do
    room = current_user_room(conn, id)
    render(conn, "show.json-api", data: room)
  end

  def update(conn, %{"id" => id, "data" => data = %{"type" => "room", "attributes" => _room_params}}) do
    room = current_user_room(conn, id)
    changeset = Room.changeset(room, Params.to_attributes(data))

    case Repo.update(changeset) do
      {:ok, room} ->
        render(conn, "show.json-api", data: room)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  defp current_user_room(conn, id) do
    current_user = Guardian.Plug.current_resource(conn)

    Room
    |> where(user_id: ^current_user.id, id: ^id)
    |> Repo.one!
  end

end
