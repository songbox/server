defmodule Songbox.ExAdmin.User do
  use ExAdmin.Register

  register_resource Songbox.User do

    index do
      selectable_column()

      column :id
      column :email
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
