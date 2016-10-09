defmodule Songbox.UserView do
  use Songbox.Web, :view
  use JaSerializer.PhoenixView

  attributes [:email]

end
