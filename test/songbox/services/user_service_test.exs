require IEx

defmodule Songbox.UserServiceTest do
  use Songbox.ModelCase

  alias Songbox.{
    User,
    UserService,
    Room,
    Repo
  }

  @valid_attrs %{email: "john.doe@example.com", password: "abcde12345", password_confirmation: "abcde12345"}

  test "'insert' creates user with room" do
    {:ok, _} = @valid_attrs
               |> UserService.insert
               |> Repo.transaction

    user = Repo.get_by(User, email: @valid_attrs[:email])
    assert user, "created a user"

    room = Repo.get_by(Room, user_id: user.id)
    assert room, "created a room"
    assert room.uid, "added a uid to room"
  end

end
