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

  defp relationships(user) do
    %{
      "user" => %{
        "data" => %{
          "type" => "user",
          "id" => user.id
        }
      }
    }
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

  test "updates and renders chosen resource when data is valid", %{conn: conn, user: user} do
    room = Repo.insert! %Room{user: user}
    conn = put conn, room_path(conn, :update, room), %{
      "meta" => %{},
      "data" => %{
        "type" => "room",
        "id" => room.id,
        "attributes" => @valid_attrs,
        "relationships" => relationships(user)
      }
    }

    assert json_response(conn, 200)["data"]["id"]
  end

  test "does not update room when current_user is not the owner", %{conn: conn, user: user} do
    other_user = Repo.insert! %User{}
    room = Repo.insert! %Room{user: other_user}

    catch_error put(conn, room_path(conn, :update, room), %{
      "data" => %{
        "type" => "room",
        "id" => room.id,
        "attributes" => @invalid_attrs
      }
    })
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, room_path(conn, :show, -1)
    end
  end

end
