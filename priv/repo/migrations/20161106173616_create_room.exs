defmodule Songbox.Repo.Migrations.CreateRoom do
  use Ecto.Migration

  def up do
    create table(:rooms) do
      add :uid, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:rooms, [:user_id])
    create unique_index(:rooms, [:uid])

    flush

    add_room_to_users()
  end

  def down do
    drop unique_index(:rooms, [:uid])
    drop index(:rooms, [:user_id])
    drop table(:rooms)
  end

  defp add_room_to_users() do
    users = Songbox.User
            |> Songbox.Repo.all
    add_room_to_users(users)
  end

  defp add_room_to_users([]), do: :ok
  defp add_room_to_users([user | others]) do
    changeset = Songbox.Room.changeset(%Songbox.Room{}, %{user_id: user.id})
    Songbox.Repo.insert!(changeset)
    add_room_to_users(others)
  end
end
