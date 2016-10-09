defmodule Songbox.RegistrationController do
  use Songbox.Web, :controller

  alias Songbox.User

  def create(conn, %{
    "data" => %{
      "type" => "user",
      "attributes" => %{
        "email" => email,
        "password" => password,
        "password_confirmation" => password_confirmation
      }
    }}) do

    changeset = User.changeset(%User{}, %{email: email,
      password_confirmation: password_confirmation,
      password: password})

    case Repo.insert changeset do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> render(Songbox.UserView, "show.json-api", data: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

end