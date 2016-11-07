defmodule Songbox.User do
  use Songbox.Web, :model

  schema "users" do
    field :email, :string
    field :password_hash, :string

    # virtual fields for password confirmation
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    has_one :room , Songbox.Room

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :password, :password_confirmation])
    |> validate_required([:email, :password, :password_confirmation])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 8)
    |> validate_confirmation(:password)
    |> hash_password
    |> unique_constraint(:email)
  end

  defp hash_password(%{valid?: false} = changeset), do: changeset
  defp hash_password(%{valid?: true} = changeset) do
    hashedpw = Comeonin.Bcrypt.hashpwsalt(Ecto.Changeset.get_field(changeset, :password))
    Ecto.Changeset.put_change(changeset, :password_hash, hashedpw)
  end

end
