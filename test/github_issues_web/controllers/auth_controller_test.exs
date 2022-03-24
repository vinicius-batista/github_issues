defmodule GithubIssuesWeb.AuthControllerTest do
  use GithubIssuesWeb.ConnCase
  alias GithubIssues.Accounts

  @valid_attrs %{
    name: "some name",
    email: "email@email.com",
    password: "test"
  }

  @valid_login %{
    email: "email@email.com",
    password: "test"
  }

  @invalid_email_login %{
    email: "email-invalid@email.com",
    password: "test"
  }

  @invalid_password_login %{
    email: "email@email.com",
    password: "test-invalid"
  }

  setup %{conn: conn} do
    {:ok, user} = Accounts.create_user(@valid_attrs)
    {:ok, token} = Accounts.create_token(%{user_id: user.id, type: "refresh-token"})

    {:ok,
     conn: put_req_header(conn, "accept", "application/json"),
     user: %Accounts.User{user | password: nil},
     refresh_token: token.refresh_token}
  end

  describe "login" do
    test "generate tokens with a valid login", %{conn: conn} do
      conn = post(conn, Routes.auth_path(conn, :login), @valid_login)
      data = json_response(conn, 200)["data"]
      assert data != %{}
      assert data["type"] == "bearer"
      assert is_bitstring(data["access_token"])
      assert is_bitstring(data["refresh_token"])
    end

    test "return 401 with an invalid email", %{conn: conn} do
      conn = post(conn, Routes.auth_path(conn, :login), @invalid_email_login)
      assert json_response(conn, 401)
    end

    test "return 401 with an invalid password", %{conn: conn} do
      conn = post(conn, Routes.auth_path(conn, :login), @invalid_password_login)
      assert json_response(conn, 401)
    end
  end

  describe "me" do
    setup :register_and_log_in_user

    test "get logged user info", %{conn: conn, user: user} do
      conn = get(conn, Routes.auth_path(conn, :me))
      data = json_response(conn, 200)["data"]
      assert data != %{}
      assert data["name"] == user.name
      assert data["email"] == user.email
      assert is_bitstring(data["inserted_at"])
      assert is_bitstring(data["updated_at"])
      assert data["id"] == user.id
    end
  end
end
