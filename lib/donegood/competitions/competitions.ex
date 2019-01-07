defmodule Donegood.Competitions do
  alias Donegood.Deeds.Deed
  use Timex
  import Ecto.Query, warn: false
  alias Donegood.Repo

  def start_dates do
    Interval.new(from: ~D[2018-11-23], step: [weeks: 1], until: Timex.now)
    |> Enum.reverse
  end

  def weekly_leaderboard_scores do
    query =
      from deed in Deed,
        join: user in assoc(deed, :user),
        select: [user.name, sum(deed.score), deed.when, deed.id, deed.user_id],
        group_by: [deed.when, deed.user_id, user.name, deed.id, deed.score]
    Repo.all(query)
  end

end
