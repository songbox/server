defmodule Songbox.UserControllerTest do
  use Songbox.ConnCase

  alias Songbox.User
  alias Songbox.Repo

  @valid_attrs %{
    email: "john.doe@example.com",
    password: "asdfjkl123",
    password_confirmation: "asdfjkl123"
  }
  @invalid_attrs %{}

  setup do
    user = Repo.insert! %User{}
    { :ok, jwt, _ } = Guardian.encode_and_sign(user, :token)

    conn = build_conn()
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")
      |> put_req_header("authorization", "Bearer #{jwt}")

    {:ok, %{conn: conn, user: user}}
  end

end
