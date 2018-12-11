defmodule DonegoodWeb.PageControllerTest do
  use DonegoodWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 302) =~ "You are being"
  end
end
