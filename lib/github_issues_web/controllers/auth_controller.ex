defmodule GithubIssuesWeb.AuthController do
  use GithubIssuesWeb, :controller
  alias GithubIssues.Accounts.Auth
  alias GithubIssuesWeb.ErrorView

  action_fallback GithubIssuesWeb.FallbackController

  def login(conn, %{"email" => email, "password" => password}) do
    with {:ok, user} <- Auth.find_user_and_check_password(email, password),
         {:ok, tokens} <- Auth.generate_tokens(user) do
      render(conn, "login.json", tokens: tokens)
    else
      {:error, message} ->
        conn
        |> put_status(:unauthorized)
        |> render(ErrorView, "401.json", message: message)
    end
  end

  def me(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    render(conn, "show.json", user: user)
  end

  def auth_error(conn, {type, _reason}, _opts) do
    conn
    |> put_status(:unauthorized)
    |> render(ErrorView, "401.json", code: type, message: "Invalid or missing access token")
  end
end
