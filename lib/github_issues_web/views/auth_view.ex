defmodule GithubIssuesWeb.AuthView do
  use GithubIssuesWeb, :view

  def render("login.json", %{tokens: tokens}) do
    %{data: tokens}
  end

  def render("show.json", %{user: user}) do
    %{
      data: %{
        id: user.id,
        email: user.email,
        name: user.name,
        inserted_at: user.inserted_at,
        updated_at: user.updated_at
      }
    }
  end
end
