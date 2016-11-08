defmodule Songbox.UserView do
  use Songbox.Web, :view
  use JaSerializer.PhoenixView

  attributes [
    :email
  ]

  has_one :room,serializer: Songbox.RoomView

end
