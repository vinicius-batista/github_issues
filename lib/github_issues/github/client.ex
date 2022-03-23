defmodule GithubIssues.Github.Client do
  use HTTPoison.Base

  def process_request_url(url) do
    "https://api.github.com#{url}"
  end

  def process_response_body(body) do
    body
    |> Jason.decode!()
  end
end
