defmodule Donegood.DeedsTest do
  use Donegood.DataCase

  alias Donegood.Deeds

  describe "deeds" do
    alias Donegood.Deeds.Deed

    @valid_attrs %{score: 42, title: "some title", when: ~D[2010-04-17]}
    @update_attrs %{score: 43, title: "some updated title", when: ~D[2011-05-18]}
    @invalid_attrs %{score: nil, title: nil, when: nil}

    def deed_fixture(attrs \\ %{}) do
      {:ok, deed} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Deeds.create_deed()

      deed
    end

    test "list_deeds/0 returns all deeds" do
      deed = deed_fixture()
      assert Deeds.list_deeds() == [deed]
    end

    test "get_deed!/1 returns the deed with given id" do
      deed = deed_fixture()
      assert Deeds.get_deed!(deed.id) == deed
    end

    test "create_deed/1 with valid data creates a deed" do
      assert {:ok, %Deed{} = deed} = Deeds.create_deed(@valid_attrs)
      assert deed.score == 42
      assert deed.title == "some title"
      assert deed.when == ~D[2010-04-17]
    end

    test "create_deed/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Deeds.create_deed(@invalid_attrs)
    end

    test "update_deed/2 with valid data updates the deed" do
      deed = deed_fixture()
      assert {:ok, %Deed{} = deed} = Deeds.update_deed(deed, @update_attrs)
      assert deed.score == 43
      assert deed.title == "some updated title"
      assert deed.when == ~D[2011-05-18]
    end

    test "update_deed/2 with invalid data returns error changeset" do
      deed = deed_fixture()
      assert {:error, %Ecto.Changeset{}} = Deeds.update_deed(deed, @invalid_attrs)
      assert deed == Deeds.get_deed!(deed.id)
    end

    test "delete_deed/1 deletes the deed" do
      deed = deed_fixture()
      assert {:ok, %Deed{}} = Deeds.delete_deed(deed)
      assert_raise Ecto.NoResultsError, fn -> Deeds.get_deed!(deed.id) end
    end

    test "change_deed/1 returns a deed changeset" do
      deed = deed_fixture()
      assert %Ecto.Changeset{} = Deeds.change_deed(deed)
    end
  end
end
