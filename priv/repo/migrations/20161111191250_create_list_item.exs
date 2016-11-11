defmodule Songbox.Repo.Migrations.CreateListItem do
  use Ecto.Migration

  def change do
    create table(:list_items) do
      add :list_id, references(:lists, on_delete: :delete_all)
      add :song_id, references(:songs, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(updated_at: false)
    end
    create index(:list_items, [:list_id])
    create index(:list_items, [:song_id])
    create index(:list_items, [:user_id])

  end
end
