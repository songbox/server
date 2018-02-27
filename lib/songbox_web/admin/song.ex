defmodule SongboxWeb.ExAdmin.Song do
  use ExAdmin.Register

  register_resource Songbox.Song do

    index do
      selectable_column()

      column :id
      column :title
      column :author
      column :user
      column :inserted_at
      actions()
    end

  end
end
