defmodule SongboxWeb.SongView do
  use Songbox.Web, :view
  use JaSerializer.PhoenixView

  attributes [
   :title,
   :author,
   :key,
   :tempo,
   :time,
   :text,
   :format,
   :license,
   :ccli,
   :inserted_at,
   :updated_at
 ]

  has_one :user,
    field: :user_id,
    type: "user"

  # workaround for ja_serializer deprecation warning
  def format(song, _conn) do
    song.format
  end

end
