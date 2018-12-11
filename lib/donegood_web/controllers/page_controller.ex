defmodule DonegoodWeb.PageController do
  use DonegoodWeb, :controller
  alias Donegood.Deeds

  def index(conn, _params) do
    scores = Deeds.weekly_leaderboard_scores
    render(conn, "index.html", %{
      weekly_leaderboard_scores: scores
      })
  end

  def signin(conn, _params) do
    render(conn, "signin.html")
  end
end
