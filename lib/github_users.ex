defmodule GithubUsers do
  def search(url) do
    cond do
      url == "" -> { :error }
      String.contains?(url, "/org/") -> {:ok, %{github_id: "sergiotapiax"}}
      String.contains?(url, "/search?") -> {:ok, %{github_id: "sergiotapiay"}}
      String.contains?(url, "/stargazers") -> {:ok, %{github_id: "sergiotapiaz"}}
      true -> scrape_profile(url)
    end
  end

  defp scrape_profile(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, %{fullname: Floki.find(body, "div.vcard-fullname") |> Floki.text,
          username: Floki.find(body, "div.vcard-username") |> Floki.text,
          location: Floki.find(body, "li[itemprop=homeLocation]") |> Floki.text,
          email: Floki.find(body, "[itemprop=email]") |> Floki.text,
          website: Floki.find(body, "[itemprop=url]") |> Floki.text,
          join_date: Floki.find(body, ".join-date") |> Floki.text,
          followers: Floki.find(body, ".vcard-stat-count") |> Enum.at(0) |> Floki.text |> String.to_integer,
          starred: Floki.find(body, ".vcard-stat-count") |> Enum.at(1) |> Floki.text |> String.to_integer,
          following: Floki.find(body, ".vcard-stat-count") |> Enum.at(2) |> Floki.text |> String.to_integer}}
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "User profile not found"}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
end
