defmodule GithubUsersTest do
  use ExUnit.Case
  doctest GithubUsers

  test "scrapes user profile" do
    { :ok, user } = GithubUsers.search("https://github.com/sergiotapia")
    IO.inspect(user)
    assert user[:email] == "sergiotapia@outlook.com"
    assert is_integer(user[:followers]) == true
    assert is_integer(user[:following]) == true
    assert is_integer(user[:starred]) == true
    assert user[:fullname] == "Sergio Tapia"
    assert user[:join_date] == "Mar 23, 2011"
    assert user[:location] == "Miami"
    assert user[:username] == "sergiotapia"
    assert user[:website] == "http://sergiotapia.me"
  end

  test "return error on empty string" do
    { result } = GithubUsers.search("")
    assert result == :error
  end
end
