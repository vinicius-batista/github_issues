defmodule GithubIssuesWeb.ErrorView do
  use GithubIssuesWeb, :view

  def render("400.json", _assigns) do
    %{errors: %{detail: "Bad Request"}}
  end

  def render("401.json", %{message: message, code: code}) do
    %{errors: %{detail: "Unauthenticated", message: message, code: code}}
  end

  def render("401.json", %{message: message}) do
    %{errors: %{detail: "Unauthenticated", message: message}}
  end

  def render("401.json", _assigns) do
    %{errors: %{detail: "Unauthenticated"}}
  end

  def render("403.json", _assigns) do
    %{errors: %{detail: "Forbidden"}}
  end

  def render("404.json", _assigns) do
    %{errors: %{detail: "Page not found"}}
  end

  def render("500.json", _assigns) do
    %{errors: %{detail: "Internal server error"}}
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render("500.json", assigns)
  end
end
