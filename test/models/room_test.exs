defmodule Songbox.RoomTest do
  use Songbox.ModelCase

  alias Songbox.Room

  @valid_attrs %{user_id: 1}

  test "generates uid" do
    changeset = Room.changeset(%Room{}, @valid_attrs)
    assert changeset.valid?
    refute fetch_field(changeset, :uid) == :error, "uid exists"
  end

end
