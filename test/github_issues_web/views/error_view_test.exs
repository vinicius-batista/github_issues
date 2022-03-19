defmodule GithubIssuesWeb.ErrorViewTest do
  use GithubIssuesWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.json" do
    assert render(GithubIssuesWeb.ErrorView, "404.json", []) == %{
             errors: %{detail: "Page not found"}
           }
  end

  test "renders 500.json" do
    assert render(GithubIssuesWeb.ErrorView, "500.json", []) ==
             %{errors: %{detail: "Internal server error"}}
  end
end
