defmodule Songbox.UserService do
  import Ecto.Changeset

  alias Ecto.Multi

  alias Songbox.{
    User,
    Room
  }

  def insert(user_params) do
    Multi.new
    |> insert_user(user_params)
  end

  defp insert_user(multi, user_params) do
    room_changeset = %Room{}
                     |> Room.changeset()
    user_changeset = %User{}
                     |> User.changeset(user_params)
                     |> put_assoc(:room, room_changeset)
    Multi.insert(multi, :user, user_changeset)
  end

end
