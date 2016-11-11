defmodule Songbox.ListItem do
  use Songbox.Web, :model

  schema "list_items" do
    belongs_to :list, Songbox.List
    belongs_to :song, Songbox.Song
    belongs_to :user, Songbox.User

    timestamps(updated_at: false)
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:list_id, :song_id, :user_id])
    |> validate_required([:list_id, :song_id, :user_id])
  end
end
