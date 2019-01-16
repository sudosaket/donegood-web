defmodule Donegood.DeedsTest do
  use Donegood.DataCase

  alias Donegood.Deeds

  describe "deeds" do
    alias Donegood.Deeds.Deed

    @valid_attrs %{score: 42, title: "some title", when: ~D[2010-04-17], user_id: 1, created_by_user_id: 2}
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

  describe "score_changes" do
    alias Donegood.Deeds.ScoreChange

    @valid_attrs %{from: 42, to: 42, user_id: 1, deed_id: 1}
    @update_attrs %{from: 43, to: 43}
    @invalid_attrs %{from: nil, to: nil}

    def score_change_fixture(attrs \\ %{}) do
      {:ok, score_change} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Deeds.create_score_change()

      score_change
    end

    test "list_score_changes/0 returns all score_changes" do
      score_change = score_change_fixture()
      assert Deeds.list_score_changes() == [score_change]
    end

    test "get_score_change!/1 returns the score_change with given id" do
      score_change = score_change_fixture()
      assert Deeds.get_score_change!(score_change.id) == score_change
    end

    test "create_score_change/1 with valid data creates a score_change" do
      assert {:ok, %ScoreChange{} = score_change} = Deeds.create_score_change(@valid_attrs)
      assert score_change.from == 42
      assert score_change.to == 42
    end

    test "create_score_change/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Deeds.create_score_change(@invalid_attrs)
    end

    test "update_score_change/2 with valid data updates the score_change" do
      score_change = score_change_fixture()
      assert {:ok, %ScoreChange{} = score_change} = Deeds.update_score_change(score_change, @update_attrs)
      assert score_change.from == 43
      assert score_change.to == 43
    end

    test "update_score_change/2 with invalid data returns error changeset" do
      score_change = score_change_fixture()
      assert {:error, %Ecto.Changeset{}} = Deeds.update_score_change(score_change, @invalid_attrs)
      assert score_change == Deeds.get_score_change!(score_change.id)
    end

    test "delete_score_change/1 deletes the score_change" do
      score_change = score_change_fixture()
      assert {:ok, %ScoreChange{}} = Deeds.delete_score_change(score_change)
      assert_raise Ecto.NoResultsError, fn -> Deeds.get_score_change!(score_change.id) end
    end

    test "change_score_change/1 returns a score_change changeset" do
      score_change = score_change_fixture()
      assert %Ecto.Changeset{} = Deeds.change_score_change(score_change)
    end
  end
end
