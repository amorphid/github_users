defmodule GithubUsersTest do
  use ExUnit.Case
  doctest GithubUsers

  # test "scrapes user profile" do
  #   { :ok, user } = GithubUsers.search("https://github.com/sergiotapia")
  #   assert user[:email] == "sergiotapia@outlook.com"
  #   assert is_integer(user[:followers]) == true
  #   assert is_integer(user[:following]) == true
  #   assert is_integer(user[:starred]) == true
  #   assert user[:fullname] == "Sergio Tapia"
  #   assert user[:join_date] == "Mar 23, 2011"
  #   assert user[:location] == "Miami"
  #   assert user[:username] == "sergiotapia"
  #   assert user[:website] == "http://sergiotapia.me"
  # end

  # test "scrapes an organization" do
  #   { :ok, users } = GithubUsers.search("https://github.com/orgs/elixir-lang/people")
  #   assert true == true
  # end

  test "scrapes an organization" do
    { :ok, users } = GithubUsers.search("https://github.com/search?q=elixir&type=Users&utf8=%E2%9C%93")
    assert true == true
  end

  test "return error on empty string" do
    { result } = GithubUsers.search("")
    assert result == :error
  end
end
