defmodule Songbox.ListView do
  use Songbox.Web, :view
  use JaSerializer.PhoenixView

  require Ecto.Query

  alias Songbox.Repo

  attributes [
    :name,
    :inserted_at,
    :updated_at
  ]

  has_many :list_items, serializer: Songbox.ListItemView, include: true

  def list_items(list, _conn) do
    case list.list_items do
      %Ecto.Association.NotLoaded{} ->
        list
        |> Ecto.assoc(:list_items)
        |> Ecto.Query.order_by(asc: :rank)
        |> Repo.all
      other -> other
    end
  end
end
