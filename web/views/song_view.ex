defmodule Songbox.SongView do
  use Songbox.Web, :view
  use JaSerializer.PhoenixView

  attributes [:title, :author, :key, :tempo, :time, :text, :format, :license, :ccli, :inserted_at, :updated_at]
  

end
