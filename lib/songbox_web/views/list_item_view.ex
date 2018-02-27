defmodule Songbox.ListItemView do
  use Songbox.Web, :view
  use JaSerializer.PhoenixView

  attributes [
    :rank,
    :inserted_at,
    :updated_at
  ]

  has_one :list,
    field: :list_id,
    type: "list"

  has_one :song,
    field: :song_id,
    type: "song"

end
