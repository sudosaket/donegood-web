defmodule DonegoodWeb.PageController do
  use DonegoodWeb, :controller

  def welcome(conn, _params) do
    render(conn, "welcome.html")
  end

  def index(conn, _params) do
    me = conn.assigns[:current_user]
    vs_users = Donegood.Accounts.list_users |> List.delete(me) |> Enum.reverse()
    my_row = Donegood.Competitions.league_table_row(me, me)
    conn
    |> redirect_if_username_missing()
    |> render("index.html", %{
      my_row: my_row,
      rows: vs_users |> Enum.map(fn user -> Donegood.Competitions.league_table_row(user, me) end)
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
end
