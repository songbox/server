defmodule SongboxWeb.ExAdmin.User do
  use ExAdmin.Register

  register_resource Songbox.User do

    index do
      selectable_column()

      column :id
      column :email, link: true
      column :inserted_at
      actions()
    end

    form user do
      inputs do
        input user, :email
        input user, :password
        input user, :password_confirmation
      end
    end

  end
end
