defmodule Songbox.UserView do
  use Songbox.Web, :view
  use JaSerializer.PhoenixView

  alias Songbox.Repo

  attributes [
    :email
  ]

  has_one :room, serializer: Songbox.RoomView

  def room(struct, conn) do
    case struct.room do
      %Ecto.Association.NotLoaded{} ->
        struct
        |> Ecto.assoc(:room)
        |> Repo.one
      other -> other
    end
  end

end
