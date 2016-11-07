defmodule Songbox.UserView do
  use Songbox.Web, :view
  use JaSerializer.PhoenixView

  attributes [
    :email
  ]

  has_many :room,
    field: :room_id,
    type: "room"

end
