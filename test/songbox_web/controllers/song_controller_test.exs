defmodule Songbox.SongControllerTest do
  use SongboxWeb.ConnCase

  alias Songbox.Song
  alias Songbox.Repo

  @valid_attrs %{author: "some content", ccli: 42, format: "some content", key: "some content", license: "some content", tempo: 42, text: "some content", time: "some content", title: "some content"}
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

  test "'GET /songs' lists all entries on index", %{conn: conn} do
    conn = get conn, song_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "'GET /songs/1' shows chosen resource", %{conn: conn, user: user} do
    song = Repo.insert! %Song{user_id: user.id}
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

  test "'GET /songs/1' does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, song_path(conn, :show, -1)
    end
  end

  test "'POST /songs' creates and renders resource when data is valid", %{conn: conn, user: user} do
    conn = post conn, song_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "song",
        "attributes" => @valid_attrs
      }
    }

    data = json_response(conn, 201)["data"]
    assert data["id"]
    assert data["relationships"]["user"]["data"]["id"] == "#{user.id}"
    assert Repo.get_by(Song, @valid_attrs)
  end

  test "'POST /songs' does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, song_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "song",
        "attributes" => @invalid_attrs
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "'PUT /songs/1' updates and renders chosen resource when data is valid", %{conn: conn, user: user} do
    song = Repo.insert! %Song{user_id: user.id}
    conn = put conn, song_path(conn, :update, song), %{
      "meta" => %{},
      "data" => %{
        "type" => "song",
        "id" => song.id,
        "attributes" => @valid_attrs
      }
    }

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Song, @valid_attrs)
  end

  test "'PUT /songs/1' does not update chosen resource and renders errors when data is invalid", %{conn: conn, user: user} do
    song = Repo.insert! %Song{user_id: user.id}
    conn = put conn, song_path(conn, :update, song), %{
      "meta" => %{},
      "data" => %{
        "type" => "song",
        "id" => song.id,
        "attributes" => @invalid_attrs
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "'DELETE /songs/1' deletes chosen resource", %{conn: conn, user: user} do
    song = Repo.insert! %Song{user_id: user.id}
    conn = delete conn, song_path(conn, :delete, song)
    assert response(conn, 204)
    refute Repo.get(Song, song.id)
  end

end
