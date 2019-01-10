defmodule Donegood.Competitions do
  alias Donegood.Deeds.Deed
  use Timex
  import Ecto.Query, warn: false
  alias Donegood.Repo
  alias Donegood.Deeds

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

  def league_table_row(user, me) do
    start_dates = Donegood.Competitions.start_dates()
    weekly_results =
      start_dates
      |> Enum.map(fn start_date ->
        weekly_result(start_date, me, user)
      end)
    this_week = List.first(start_dates)
    four_weeks_ago = start_dates |> Enum.at(4)
    this_week_fixture = %{
      points: Deeds.score_for_period(this_week, user),
      acts: Deeds.deeds_for_period(this_week, user) |> Enum.count
    }
    %Donegood.Competitions.LeagueTableRow{
      user: user,
      this_week: this_week_fixture,
      last_4_weeks: fixture_since(
        four_weeks_ago,
        user,
        weekly_results |> Enum.filter(fn week ->
          NaiveDateTime.compare(week.start_date, four_weeks_ago) == :gt
          and NaiveDateTime.compare(this_week, week.start_date) == :gt
        end)
      ),
      all_time: fixture_since(
        List.last(start_dates),
        user,
        weekly_results |> List.delete( List.first(weekly_results) )
      )
    }
  end
  
  defp fixture_since(start_date, user, weekly_results) do
    IO.inspect(start_date: start_date, weekly_results: weekly_results)
    %{
      points: Deeds.score_for_period(start_date, user),
      acts: Deeds.deeds_for_period(start_date, user) |> Enum.count,
      wins: weekly_results |> Enum.map(fn week -> if week.result == :win, do: 1, else: 0 end )|> Enum.sum,
      losses: weekly_results |> Enum.map(fn week -> if week.result == :loss, do: 1, else: 0 end )|> Enum.sum,
      draws: weekly_results |> Enum.map(fn week -> if week.result == :draw, do: 1, else: 0 end )|> Enum.sum
    }
  end

  defp weekly_result(start_date, me, them) do
    my_points = Deeds.score_for_period(start_date, me)
    their_points = Deeds.score_for_period(start_date, them)

    result = cond do
      (my_points > their_points) -> :win
      (my_points < their_points) -> :loss
      true -> :draw
    end
    %Donegood.Competitions.WeeklyResult{
      start_date: start_date,
      result: result,
      my_points: my_points,
      my_acts_count: Deeds.deeds_for_period(start_date, me) |> Enum.count,
      their_points: their_points,
      their_acts_count: Deeds.deeds_for_period(start_date, them) |> Enum.count
    }
  end

end
