defmodule Songbox.SessionControllerTest do
  use Songbox.ConnCase

  alias Songbox.User

  @valid_attrs %{
    email: "john.doe@example.com",
    password: "asdfjkl123",
    password_confirmation: "asdfjkl123"
  }

  setup do
    conn = build_conn()
      |> put_req_header("content-type", "application/json")

    {:ok, conn: conn}
  end

  test "token: return token with valid credentials", %{conn: conn} do
    changeset = User.changeset(%User{}, @valid_attrs)
    user = Repo.insert! changeset

    conn = post conn, login_path(conn, :create), %{
      grant_type: "password",
      username: user.email,
      password: user.password
    }
    assert json_response(conn, 200)["access_token"]
  end

  test "token: fail with invalid credentials", %{conn: conn} do
    changeset = User.changeset(%User{}, @valid_attrs)
    user = Repo.insert! changeset

    conn = post conn, login_path(conn, :create), %{
      grant_type: "password",
      username: user.email,
      password: "!invalidPa55word"
    }
    assert json_response(conn, 401)["errors"]
  end

  test "token: fail with missing credentials", %{conn: conn} do
    catch_throw(
      post conn, login_path(conn, :create), %{
        grant_type: "password"
      }
    )
  end

  test "token: fail with unsupported grant type", %{conn: conn} do
    catch_throw(
      post conn, login_path(conn, :create), %{
        grant_type: "other"
      }
    )
  end

end
