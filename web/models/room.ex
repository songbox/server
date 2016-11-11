defmodule Songbox.Room do
  use Songbox.Web, :model

  schema "rooms" do
    field :uid, :string

    belongs_to :user, Songbox.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id])
    |> validate_required([:user_id])
    |> generate_uid()
    |> validate_length(:uid, min: 7)
    |> unique_constraint(:uid)
  end

  defp generate_uid(changeset) do
    put_change(changeset, :uid, unique_random_string(7))
  end

  defp unique_random_string(length) do
    uid = random_string(length)
    room = Songbox.Room
           |> where(uid: ^uid)
           |> Songbox.Repo.one

    if room do
      random_string(length)
    else
      uid
    end
  end

  defp random_string(length) do
    length
    |> :crypto.strong_rand_bytes
    |> Base.url_encode64
    |> binary_part(0, length)
  end
end
