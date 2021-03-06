defmodule DonegoodWeb.PageController do
  use DonegoodWeb, :controller
  alias Donegood.{Accounts,Competitions}


  def welcome(conn, _params) do
    render(conn, "welcome.html")
  end

  def index(conn, _params) do
    me = conn.assigns[:current_user]
    vs_users = Accounts.participating_users() |> List.delete(me) |> Enum.reverse()
    my_row = Competitions.league_table_row(me, me)
    vs_rows = vs_users |> Enum.map(fn user -> Competitions.league_table_row(user, me) end)
    conn
    |> redirect_if_username_missing()
    |> flash_if_not_participating(me)
    |> render("index.html", %{
      lurkers: Accounts.lurkers,
      my_row: my_row,
      vs_rows: vs_rows,
      all_rows:
        vs_rows
        |> List.insert_at(0, my_row)
        |> Enum.sort_by(fn row -> row.this_week.points end)
        |> Enum.reverse
      })
  end

  def signin(conn, _params) do
    render(conn, "signin.html")
  end

  def faq(conn, _params) do
    render(conn, "faq.html")
  end

  defp redirect_if_username_missing(conn) do
    case DonegoodWeb.UserHelper.current_user(conn) do
      nil ->
        conn |> redirect(to: Routes.page_path(conn, :welcome))
      user ->
        IO.inspect(USER: user)
        if is_nil(user.username) do
          conn
          |> put_flash(:error, "Please provide a username")
          |> redirect(to: Routes.user_path(conn, :edit, user))
        else
          conn
        end
    end

  end

  defp flash_if_not_participating(conn,me) do
    case me.participating do
      true -> conn
      _ -> put_flash(conn, :info, "You are not yet participating in the league. To join in, click your name above and check the 'Participating?' box.")
    end
  end
end
