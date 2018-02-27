defmodule Songbox.UserView do
  use Songbox.Web, :view
  use JaSerializer.PhoenixView

  alias Songbox.Repo

  attributes [
    :email
  ]

  has_one :room, serializer: Songbox.RoomView, include: true

  def room(struct, _conn) do
    case struct.room do
      %Ecto.Association.NotLoaded{} ->
        struct
        |> Ecto.assoc(:room)
        |> Repo.one
      other -> other
    end
  end

end
