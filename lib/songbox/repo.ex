defmodule Songbox.Repo do
  use Ecto.Repo, otp_app: :songbox
  use Scrivener, page_size: 10
end
