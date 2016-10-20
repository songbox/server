defmodule Songbox.Repo.Migrations.AddUserIdToSongs do
  use Ecto.Migration

  def change do
    alter table(:songs) do
      add :user_id, references(:users, on_delete: :nothing)
    end

    create index(:songs, [:user_id])
  end
end
