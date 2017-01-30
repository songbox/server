defmodule Songbox.UserControllerTest do
  use Songbox.ConnCase

  alias Songbox.{
    User,
    Room,
    Repo
  }

  setup do
    user = Repo.insert! %User{}
    { :ok, jwt, _ } = Guardian.encode_and_sign(user, :token)

    conn = build_conn()
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")
      |> put_req_header("authorization", "Bearer #{jwt}")

    {:ok, %{conn: conn, user: user}}
  end

  test "shows current user", %{conn: conn, user: user} do
    room = Repo.insert! %Room{user: user}

    conn = get conn, user_path(conn, :current)
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{user.id}"
    assert data["type"] == "user"
    assert data["attributes"]["email"] == user.email
    assert data["relationships"]["room"]["data"]["id"] == "#{room.id}"
  end
end
