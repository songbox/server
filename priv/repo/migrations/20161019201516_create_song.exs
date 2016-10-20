defmodule Songbox.Repo.Migrations.CreateSong do
  use Ecto.Migration

  def change do
    create table(:songs) do
      add :title, :string
      add :author, :string
      add :key, :string
      add :tempo, :integer
      add :time, :string
      add :text, :string
      add :format, :string
      add :license, :string
      add :ccli, :integer

      timestamps()
    end
  end
end
