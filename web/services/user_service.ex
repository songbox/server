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
    changeset = %User{}
                |> User.changeset(user_params)
                |> put_assoc(:room, %Room{})
    Multi.insert(multi, :user, changeset)
  end

end
