defmodule GithubUsersTest do
  use ExUnit.Case
  doctest GithubUsers

  test "scrapes user profile" do
    user = GithubUsers.search("https://github.com/sergiotapia")
    assert user[:email] == "sergiotapia@outlook.com"
    assert user[:followers] != nil
    assert user[:following] != nil
    assert user[:starred] != nil
    assert user[:fullname] == "Sergio Tapia"
    assert user[:join_date] == "Mar 23, 2011"
    assert user[:location] == "Miami"
    assert user[:username] == "sergiotapia"
    assert user[:website] == "http://sergiotapia.me"
  end

  test "scrapes an organization" do
    users = GithubUsers.search("https://github.com/orgs/elixir-lang/people")
    assert is_list(users) == true
  end

  test "scrapes a search" do
    users = GithubUsers.search("https://github.com/search?q=elixir&type=Users&utf8=%E2%9C%93")
    assert is_list(users) == true
  end

  test "scrapes a search" do
    users = GithubUsers.search("https://github.com/elixir-lang/elixir/stargazers")
    assert is_list(users) == true
  end

  test "return error on empty string" do
    { :error, reason} = GithubUsers.search("")
    assert reason == "Can't search for an empty string"
  end
end
