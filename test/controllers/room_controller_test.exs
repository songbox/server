defmodule Songbox.RoomControllerTest do
  use Songbox.ConnCase

  alias Songbox.Room
  alias Songbox.User
  alias Songbox.Repo

  @valid_attrs %{uid: "some content"}
  @invalid_attrs %{}

  setup do
    user = Repo.insert! %User{}
    { :ok, jwt, _ } = Guardian.encode_and_sign(user, :token)

    conn = build_conn()
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")
      |> put_req_header("authorization", "Bearer #{jwt}")

    {:ok, %{conn: conn, user: user}}
  end

  test "shows chosen resource", %{conn: conn, user: user} do
    room = Repo.insert! %Room{user_id: user.id}
    conn = get conn, room_path(conn, :show, room)
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{room.id}"
    assert data["type"] == "room"
    assert data["attributes"]["uid"] == room.uid
    assert data["relationships"]["user"]["data"]["id"] == "#{room.user_id}"
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, room_path(conn, :show, -1)
    end
  end

end
