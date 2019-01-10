defmodule Donegood.Competitions.LeagueTableRow do
  alias Donegood.Competitions.LeagueTableFixture
  defstruct user: %Donegood.Accounts.User{}, 
            this_week: %LeagueTableFixture{},
            last_4_weeks: %LeagueTableFixture{},
            all_time: %LeagueTableFixture{}
end
