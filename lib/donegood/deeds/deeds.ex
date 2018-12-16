defmodule Donegood.Deeds do
  @moduledoc """
  The Deeds context.
  """

  import Ecto.Query, warn: false
  alias Donegood.Repo

  alias Donegood.Deeds.Deed

  alias Donegood.Deeds.ScoreChange

  @doc """
  Returns the list of deeds.

  ## Examples

      iex> list_deeds()
      [%Deed{}, ...]

  """
  def list_deeds do
    Repo.all(Deed) |> Repo.preload([:user, :comments])
  end



  def weekly_leaderboard_scores do
    query =
      from deed in Deed,
        join: user in assoc(deed, :user),
        select: [user.name, sum(deed.score), deed.when, deed.id, deed.user_id],
        group_by: [deed.when, deed.user_id, user.name, deed.id, deed.score]
    Repo.all(query)
  end


  def deeds_for_period(start_date, user) do
    query =
      from deed in Deed,
        where: fragment(
          "? = ? AND ((? >= ? AND ? < ?) OR (? = ? AND ? < ?))",
          deed.user_id,
          ^user.id,
          deed.when,
          ^NaiveDateTime.to_date(start_date),
          deed.when,
          ^NaiveDateTime.to_date(Timex.shift(start_date, weeks: 1)),
          deed.repeats,
          ^true,
          deed.when,
          ^NaiveDateTime.to_date(start_date)
        )
    Repo.all(query) |> Repo.preload(:comments)
  end

  def score_for_period(start_date, user) do
    deeds_for_period(start_date, user)
    |> Enum.reduce(0, fn(deed), score -> deed.score + score end)

  end

  def summary_for_period(start_date,user) do
    deeds_for_period(start_date, user)
    |> Enum.reduce("", fn(deed), summary -> deed.title <> ", " <> summary end)
  end

  @doc """
  Gets a single deed.

  Raises `Ecto.NoResultsError` if the Deed does not exist.

  ## Examples

      iex> get_deed!(123)
      %Deed{}

      iex> get_deed!(456)
      ** (Ecto.NoResultsError)

  """
  def get_deed!(id), do: Deed |> Repo.get!(id) |> Repo.preload([:user, :comments, [score_changes: :user]])

  @doc """
  Creates a deed.

  ## Examples

      iex> create_deed(%{field: value})
      {:ok, %Deed{}}

      iex> create_deed(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_deed(attrs \\ %{}) do
    %Deed{}
    |> Deed.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a deed.

  ## Examples

      iex> update_deed(deed, %{field: new_value})
      {:ok, %Deed{}}

      iex> update_deed(deed, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_deed(%Deed{} = deed, attrs, current_user) do
    if deed.score != attrs["score"] do
      IO.inspect(changing_score: [current_user, attrs, deed])
      %ScoreChange{}
      |> ScoreChange.changeset(%{
        "from" => deed.score,
        "to" => attrs["score"],
        "user_id" => current_user.id,
        "deed_id" => deed.id
        })
      |> Repo.insert!()
    end

    deed
    |> Deed.changeset(attrs)
    |> Repo.update()

  end

  @doc """
  Deletes a Deed.

  ## Examples

      iex> delete_deed(deed)
      {:ok, %Deed{}}

      iex> delete_deed(deed)
      {:error, %Ecto.Changeset{}}

  """
  def delete_deed(%Deed{} = deed) do
    Repo.delete(deed)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking deed changes.

  ## Examples

      iex> change_deed(deed)
      %Ecto.Changeset{source: %Deed{}}

  """
  def change_deed(%Deed{} = deed) do
    Deed.changeset(deed, %{})
  end




  alias Donegood.Deeds.ScoreChange


  @doc """
  Creates a score_change.

  ## Examples

      iex> create_score_change(%{field: value})
      {:ok, %ScoreChange{}}

      iex> create_score_change(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_score_change(attrs \\ %{}) do
    %ScoreChange{}
    |> ScoreChange.changeset(attrs)
    |> Repo.insert()
  end


  @doc """
  Deletes a ScoreChange.

  ## Examples

      iex> delete_score_change(score_change)
      {:ok, %ScoreChange{}}

      iex> delete_score_change(score_change)
      {:error, %Ecto.Changeset{}}

  """
  def delete_score_change(%ScoreChange{} = score_change) do
    Repo.delete(score_change)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking score_change changes.

  ## Examples

      iex> change_score_change(score_change)
      %Ecto.Changeset{source: %ScoreChange{}}

  """
  def change_score_change(%ScoreChange{} = score_change) do
    ScoreChange.changeset(score_change, %{})
  end
end
