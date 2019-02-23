defmodule Songbox.Song do
  use Ecto.Schema
  import Ecto.Changeset

  schema "songs" do
    field :title, :string
    field :author, :string
    field :key, :string
    field :tempo, :integer
    field :time, :string
    field :text, :string
    field :format, :string
    field :license, :string
    field :ccli, :integer

    belongs_to :user, Songbox.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :author, :key, :tempo, :time, :text, :format, :license, :ccli])
    |> validate_required([:user_id, :title, :text, :format])
  end
end
