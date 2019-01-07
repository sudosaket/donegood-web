defmodule DonegoodWeb.CompetitionController do
  use DonegoodWeb, :controller
  alias Donegood.Accounts

  def fixture(conn, params) do
    user = Accounts.get_user_by_username!(params["username"])
    other_user = Accounts.get_user_by_username!(params["other_username"])
    render(conn, "fixture.html", competing_users: [user, other_user])
  end
end
