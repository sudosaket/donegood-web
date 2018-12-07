defmodule Donegood.Auth.ErrorHandler do
  import Plug.Conn

  def auth_error(conn, {_type, _reason}, _opts) do
    conn
    |> Phoenix.Controller.put_flash(:error, "Login required")
    |> Phoenix.Controller.redirect(to: "/auth/sign-in")
    |> halt()
  end
end
