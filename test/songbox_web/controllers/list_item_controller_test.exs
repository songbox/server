defmodule Songbox.ListItemControllerTest do
  use SongboxWeb.ConnCase

  alias Songbox.ListItem
  alias Songbox.Repo

  @valid_attrs %{}
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
    list = Repo.insert!(%Songbox.List{})
    song = Repo.insert!(%Songbox.Song{})

    %{
      "list" => %{
        "data" => %{
          "type" => "list",
          "id" => list.id
        }
      },
      "song" => %{
        "data" => %{
          "type" => "song",
          "id" => song.id
        }
      },
    }
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, list_item_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn, user: user} do
    list_item = Repo.insert! %ListItem{user_id: user.id}
    conn = get conn, list_item_path(conn, :show, list_item)
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{list_item.id}"
    assert data["type"] == "list-item"
    assert data["attributes"]["list_id"] == list_item.list_id
    assert data["attributes"]["song_id"] == list_item.song_id
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, list_item_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, list_item_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "list-item",
        "attributes" => @valid_attrs,
        "relationships" => relationships()
      }
    }

    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(ListItem, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, list_item_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "list-item",
        "attributes" => @invalid_attrs,
        "relationships" => %{}
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn, user: user} do
    list_item = Repo.insert! %ListItem{user_id: user.id}
    conn = put conn, list_item_path(conn, :update, list_item), %{
      "meta" => %{},
      "data" => %{
        "type" => "list-item",
        "id" => list_item.id,
        "attributes" => @valid_attrs,
        "relationships" => relationships()
      }
    }

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(ListItem, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    list_item = Repo.insert! %ListItem{}
    catch_error put(conn, list_item_path(conn, :update, list_item), %{
      "meta" => %{},
      "data" => %{
        "type" => "list-item",
        "id" => list_item.id,
        "attributes" => @invalid_attrs,
        "relationships" => relationships()
      }
    })
  end

  test "deletes chosen resource", %{conn: conn, user: user} do
    list_item = Repo.insert! %ListItem{user_id: user.id}
    conn = delete conn, list_item_path(conn, :delete, list_item)
    assert response(conn, 204)
    refute Repo.get(ListItem, list_item.id)
  end

end
