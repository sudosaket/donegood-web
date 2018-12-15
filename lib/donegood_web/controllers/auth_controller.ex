defmodule DonegoodWeb.AuthController do
  use DonegoodWeb, :controller
  import Phoenix.HTML.Link
  alias Donegood.UserFromAuth
  alias Donegood.Auth.Guardian
  plug Ueberauth

  def callback(%Plug.Conn{ assigns: %{ ueberauth_failure: _fails } } = conn, _params) do
    IO.puts("Oh no")
    conn
    |> put_flash(:error, "Failed to authenticate")
    |> redirect(to: "/")
  end

  def callback(%Plug.Conn{ assigns: %{ ueberauth_auth: auth } } = conn, _params) do
    case UserFromAuth.find_or_create(auth) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Signed in as #{user.name}")
        |> prompt_if_email_missing(user)
        |> Guardian.Plug.sign_in(user)
        |> redirect(to: "/")
      {:error, reason} ->
        conn
        |> put_flash(:error, "Could not authenticate because #{reason}")
        |> redirect(to: "/")
    end
  end

  def logout(conn, _params) do
    conn
    |> Guardian.Plug.sign_out
    |> put_flash(:info, "Logged out")
    |> redirect(to: "/auth/sign-in")

  end

  def prompt_if_email_missing(conn, user) do
    if is_nil(user.email) do
      put_flash(conn, :error, [
        "Please ",
        link("provide your email address", to: Routes.user_path(conn, :edit, user))
        ])
    else
      conn
    end
  end
end
