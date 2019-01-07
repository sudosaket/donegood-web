defmodule DonegoodWeb.PageController do
  use DonegoodWeb, :controller

  def welcome(conn, _params) do
    render(conn, "welcome.html")
  end

  def index(conn, _params) do
    conn
    |> redirect_if_username_missing()
    |> render("index.html", %{
      users: Donegood.Accounts.list_users
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
