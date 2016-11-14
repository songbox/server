defmodule Songbox.Repo.Migrations.AddPositionToListItems do
  use Ecto.Migration

  def change do
    alter table(:list_items) do
      remove :inserted_at
      add :rank, :integer

      timestamps
    end
  end
end
