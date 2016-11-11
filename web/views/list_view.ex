defmodule Songbox.ListView do
  use Songbox.Web, :view
  use JaSerializer.PhoenixView

  attributes [:name, :inserted_at, :updated_at]
  
  has_one :user,
    field: :user_id,
    type: "user"

end
