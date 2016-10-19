defmodule Songbox.SongControllerTest do
  use Songbox.ConnCase

  alias Songbox.Song
  alias Songbox.Repo

  @valid_attrs %{author: "some content", ccli: 42, format: "some content", key: "some content", license: "some content", tempo: 42, text: "some content", time: "some content", title: "some content"}
  @invalid_attrs %{}

  setup do
    conn = build_conn()
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end

  defp relationships do
    %{}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, song_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    song = Repo.insert! %Song{}
    conn = get conn, song_path(conn, :show, song)
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{song.id}"
    assert data["type"] == "song"
    assert data["attributes"]["title"] == song.title
    assert data["attributes"]["author"] == song.author
    assert data["attributes"]["key"] == song.key
    assert data["attributes"]["tempo"] == song.tempo
    assert data["attributes"]["time"] == song.time
    assert data["attributes"]["text"] == song.text
    assert data["attributes"]["format"] == song.format
    assert data["attributes"]["license"] == song.license
    assert data["attributes"]["ccli"] == song.ccli
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, song_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, song_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "song",
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Song, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, song_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "song",
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    song = Repo.insert! %Song{}
    conn = put conn, song_path(conn, :update, song), %{
      "meta" => %{},
      "data" => %{
        "type" => "song",
        "id" => song.id,
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Song, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    song = Repo.insert! %Song{}
    conn = put conn, song_path(conn, :update, song), %{
      "meta" => %{},
      "data" => %{
        "type" => "song",
        "id" => song.id,
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    song = Repo.insert! %Song{}
    conn = delete conn, song_path(conn, :delete, song)
    assert response(conn, 204)
    refute Repo.get(Song, song.id)
  end

end
