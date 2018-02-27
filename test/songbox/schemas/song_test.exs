defmodule Songbox.SongTest do
  use Songbox.ModelCase

  alias Songbox.Song

  @valid_attrs %{author: "some content", ccli: 42, format: "some content", key: "some content", license: "some content", tempo: 42, text: "some content", time: "some content", title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    user = Repo.insert! %Songbox.User{}
    changeset = Song.changeset(%Song{user_id: user.id}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Song.changeset(%Song{}, @invalid_attrs)
    refute changeset.valid?
  end
end
