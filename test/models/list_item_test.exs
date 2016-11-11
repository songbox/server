defmodule Songbox.ListItemTest do
  use Songbox.ModelCase

  alias Songbox.ListItem

  @valid_attrs %{list_id: 1, song_id: 1, user_id: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ListItem.changeset(%ListItem{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ListItem.changeset(%ListItem{}, @invalid_attrs)
    refute changeset.valid?
  end
end
