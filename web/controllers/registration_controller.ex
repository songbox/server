defmodule Songbox.RegistrationController do
  use Songbox.Web, :controller

  alias Songbox.{
    User,
    UserService,
    Repo
  }

  def create(conn, %{
    "data" => %{
      "type" => "user",
      "attributes" => %{
        "email" => email,
        "password" => password,
        "password_confirmation" => password_confirmation
      }
    }}) do

    params = %{
      email: email,
      password: password,
      password_confirmation: password_confirmation
    }

    result = params
             |> UserService.insert
             |> Repo.transaction

    case result do
      {:ok, %{user: user}} ->
        conn
        |> put_status(:created)
        |> render(Songbox.UserView, "show.json-api", data: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Songbox.UserView, :errors, data: changeset)
    end
  end

end
