defmodule DonegoodWeb.PageController do
  use DonegoodWeb, :controller

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


  defp redirect_if_username_missing(conn) do
    user = DonegoodWeb.UserHelper.current_user(conn)
    if is_nil(user.username) do
      conn
      |> put_flash(:error, "Please provide a username")
      |> redirect(to: Routes.user_path(conn, :edit, user))
    else
      conn
    end
  end
end
