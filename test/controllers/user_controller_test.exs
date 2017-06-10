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

    conn = get conn, user_path(conn, :show_current)
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{user.id}"
    assert data["type"] == "user"
    assert data["attributes"]["email"] == user.email
    assert data["relationships"]["room"]["data"]["id"] == "#{room.id}"
  end

  test "updates password and renders current user when data is valid", %{conn: conn, user: user} do
    attributes = %{
      email: "john.doe@test.com",
      password: "12345678",
      password_confirmation: "12345678"
    }

    conn = put conn, user_path(conn, :update_current), %{
      "meta" => %{},
      "data" => %{
        "type" => "user",
        "id" => user.id,
        "attributes" => attributes
      }
    }

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(User, %{ email: "john.doe@test.com" })
  end

end
