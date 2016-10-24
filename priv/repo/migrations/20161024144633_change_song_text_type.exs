defmodule Songbox.Repo.Migrations.ChangeSongTextType do
  use Ecto.Migration

  def change do
    alter table(:songs) do
      modify :text, :text
    end
  end
end
