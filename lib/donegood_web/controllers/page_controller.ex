defmodule DonegoodWeb.PageController do
  use DonegoodWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
