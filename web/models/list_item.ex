defmodule Songbox.ListItem do
  use Songbox.Web, :model
  import EctoOrdered

  schema "list_items" do
    field :rank, :integer
    field :position, :integer, virtual: true

    belongs_to :list, Songbox.List
    belongs_to :song, Songbox.Song
    belongs_to :user, Songbox.User

    timestamps
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:position, :list_id, :song_id, :user_id])
    |> validate_required([:list_id, :song_id, :user_id])
    |> set_order(:position, :rank, :list_id)
  end
end
