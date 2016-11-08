defmodule Songbox.RegistrationControllerTest do
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
    conn = build_conn()
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, registration_path(conn, :create), %{
      data: %{
        type: "user",
        attributes: @valid_attrs
      }
    }
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(User, %{email: @valid_attrs[:email]})
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    assert_error_sent 400, fn ->
      post conn, registration_path(conn, :create),  %{
        data: %{
          type: "user",
          attributes: @invalid_attrs
        }
      }
    end
  end

end
