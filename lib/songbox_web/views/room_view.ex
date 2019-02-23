defmodule SongboxWeb.RoomView do
  use Songbox.Web, :view
  use JaSerializer.PhoenixView

  attributes [
    :uid,
    :inserted_at,
    :updated_at
  ]

  has_one :user,
    field: :user_id,
    type: "user"

end
