defmodule Songbox.ListControllerTest do
  use Songbox.ConnCase

  alias Songbox.List
  alias Songbox.Repo

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  setup do
    user = Repo.insert! %Songbox.User{}
    { :ok, jwt, _ } = Guardian.encode_and_sign(user, :token)

    conn = build_conn()
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")
      |> put_req_header("authorization", "Bearer #{jwt}")

    {:ok, %{conn: conn, user: user}}
  end

  defp relationships do
    user = Repo.insert!(%Songbox.User{})

    %{
      "user" => %{
        "data" => %{
          "type" => "user",
          "id" => user.id
        }
      },
    }
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, list_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn, user: user} do
    list = Repo.insert! %List{user_id: user.id}
    conn = get conn, list_path(conn, :show, list)
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{list.id}"
    assert data["type"] == "list"
    assert data["attributes"]["name"] == list.name
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, list_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, list_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "list",
        "attributes" => @valid_attrs,
        "relationships" => relationships()
      }
    }

    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(List, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, list_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "list",
        "attributes" => @invalid_attrs,
        "relationships" => relationships()
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn, user: user} do
    list = Repo.insert! %List{user_id: user.id}
    conn = put conn, list_path(conn, :update, list), %{
      "meta" => %{},
      "data" => %{
        "type" => "list",
        "id" => list.id,
        "attributes" => @valid_attrs,
        "relationships" => relationships()
      }
    }

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(List, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, user: user} do
    list = Repo.insert! %List{user_id: user.id}
    conn = put conn, list_path(conn, :update, list), %{
      "meta" => %{},
      "data" => %{
        "type" => "list",
        "id" => list.id,
        "attributes" => @invalid_attrs,
        "relationships" => relationships()
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn, user: user} do
    list = Repo.insert! %List{user_id: user.id}
    conn = delete conn, list_path(conn, :delete, list)
    assert response(conn, 204)
    refute Repo.get(List, list.id)
  end

end
