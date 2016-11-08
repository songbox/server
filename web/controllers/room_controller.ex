defmodule Songbox.RoomController do
  use Songbox.Web, :controller

  alias Songbox.Room
  alias JaSerializer.Params

  def show(conn, %{"id" => id}) do
    room = current_user_room(conn, id)
    render(conn, "show.json-api", data: room)
  end

  defp current_user_room(conn, id) do
    current_user = Guardian.Plug.current_resource(conn)

    Room
    |> where(user_id: ^current_user.id, id: ^id)
    |> Repo.one!
  end

end
