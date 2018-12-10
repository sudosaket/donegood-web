defmodule Donegood.Deeds do
  @moduledoc """
  The Deeds context.
  """

  import Ecto.Query, warn: false
  alias Donegood.Repo

  alias Donegood.Deeds.Deed

  @doc """
  Returns the list of deeds.

  ## Examples

      iex> list_deeds()
      [%Deed{}, ...]

  """
  def list_deeds do
    Repo.all(Deed) |> Repo.preload(:user)
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
          "? = ? AND ? BETWEEN ? AND ?",
          deed.user_id, ^user.id, deed.when, ^NaiveDateTime.to_date(start_date), ^NaiveDateTime.to_date(Timex.shift(start_date, weeks: 1))
        )
    Repo.all(query)
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
  def get_deed!(id), do: Repo.get!(Deed, id)

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
  def update_deed(%Deed{} = deed, attrs) do
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



end
