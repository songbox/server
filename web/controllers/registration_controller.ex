defmodule Songbox.RegistrationController do
  use Songbox.Web, :controller

  alias Songbox.{
    UserService,
    Repo
  }
  alias JaSerializer.Params

  def create(conn, %{"data" => data}) do
    params = Params.to_attributes(data)

    result = params
             |> UserService.insert
             |> Repo.transaction

    case result do
      {:ok, %{user: user}} ->
        conn
        |> put_status(:created)
        |> render(Songbox.UserView, "show.json-api", data: user)
      {:error, :user, changeset, _} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Songbox.UserView, "errors.json-api", data: changeset)
    end
  end

end
