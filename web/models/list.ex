defmodule Songbox.List do
  use Songbox.Web, :model

  schema "lists" do
    field :name, :string

    belongs_to :user, Songbox.User
    has_many :list_items, Songbox.ListItem
    many_to_many :songs, Songbox.Song, join_through: :list_items

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :user_id])
    |> validate_required([:name, :user_id])
  end
end
