defmodule GithubUsers do
  def search(url) do
    cond do
      url == "" -> { :error }
      String.contains?(url, "/orgs/") -> scrape_organization(url)
      String.contains?(url, "/search?") -> scrape_search(url)
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
          followers: Floki.find(body, ".vcard-stat-count") |> Enum.at(0) |> Floki.text,
          starred: Floki.find(body, ".vcard-stat-count") |> Enum.at(1) |> Floki.text,
          following: Floki.find(body, ".vcard-stat-count") |> Enum.at(2) |> Floki.text}}
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "User profile not found"}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  defp scrape_organization(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, Floki.find(body, "a.member-link") |> Floki.attribute("href") |> Enum.map(fn(x) -> "https://github.com#{x}" end) |> Enum.map(fn(x) -> scrape_profile(x) end ) }
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "User profile not found"}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  defp scrape_search(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, Floki.find(body, "div.user-list-item a") |> Floki.attribute("href")
                                                       |> Enum.uniq
                                                       |> Enum.reject(fn(x) -> String.contains?(x, "/login") end)
                                                       |> Enum.reject(fn(x) -> String.contains?(x, "mailto:") end)
                                                       |> Enum.map(fn(x) -> "https://github.com#{x}" end)
                                                       |> Enum.map(fn(x) -> scrape_profile(x) end ) }
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "User profile not found"}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
end
