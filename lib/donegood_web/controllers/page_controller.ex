defmodule DonegoodWeb.PageController do
  use DonegoodWeb, :controller

  def index(conn, _params) do
    IO.puts("Hello")
    render(conn, "index.html")
  end

  def signin(conn, _params) do
    render(conn, "signin.html")
  end
end
