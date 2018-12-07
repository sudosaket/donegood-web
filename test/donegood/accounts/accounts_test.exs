defmodule Donegood.AccountsTest do
  use Donegood.DataCase

  alias Donegood.Accounts

  describe "users" do
    alias Donegood.Accounts.User

    @valid_attrs %{email: "some email", facebook_id: "some facebook_id", facebook_token: "some facebook_token", google_id: "some google_id", google_token: "some google_token", name: "some name", twitter_id: "some twitter_id"}
    @update_attrs %{email: "some updated email", facebook_id: "some updated facebook_id", facebook_token: "some updated facebook_token", google_id: "some updated google_id", google_token: "some updated google_token", name: "some updated name", twitter_id: "some updated twitter_id"}
    @invalid_attrs %{email: nil, facebook_id: nil, facebook_token: nil, google_id: nil, google_token: nil, name: nil, twitter_id: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "some email"
      assert user.facebook_id == "some facebook_id"
      assert user.facebook_token == "some facebook_token"
      assert user.google_id == "some google_id"
      assert user.google_token == "some google_token"
      assert user.name == "some name"
      assert user.twitter_id == "some twitter_id"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.email == "some updated email"
      assert user.facebook_id == "some updated facebook_id"
      assert user.facebook_token == "some updated facebook_token"
      assert user.google_id == "some updated google_id"
      assert user.google_token == "some updated google_token"
      assert user.name == "some updated name"
      assert user.twitter_id == "some updated twitter_id"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
