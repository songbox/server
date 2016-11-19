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
  @invalid_attrs %{}

  test "'insert' creates user with room" do
    {:ok, _} = @valid_attrs
               |> UserService.insert
               |> Repo.transaction
    user = Repo.get_by(User, email: @valid_attrs[:email])
    assert user, "creates a user"
    assert Repo.get_by(Room, user_id: user.id), "created a room"
  end

end
