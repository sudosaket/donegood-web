defmodule DonegoodWeb.ScoreChangeControllerTest do
  use DonegoodWeb.ConnCase

  alias Donegood.Deeds

  @create_attrs %{from: 42, to: 42, user_id: 1, deed_id: 1}
  @update_attrs %{from: 43, to: 43}
  @invalid_attrs %{from: nil, to: nil}

  def fixture(:score_change) do
    {:ok, score_change} = Deeds.create_score_change(@create_attrs)
    score_change
  end

  describe "index" do
    test "lists all score_changes", %{conn: conn} do
      conn = get(conn, Routes.score_change_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Score changes"
    end
  end

  describe "new score_change" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.score_change_path(conn, :new))
      assert html_response(conn, 200) =~ "New Score change"
    end
  end

  describe "create score_change" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.score_change_path(conn, :create), score_change: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.score_change_path(conn, :show, id)

      conn = get(conn, Routes.score_change_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Score change"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.score_change_path(conn, :create), score_change: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Score change"
    end
  end

  describe "edit score_change" do
    setup [:create_score_change]

    test "renders form for editing chosen score_change", %{conn: conn, score_change: score_change} do
      conn = get(conn, Routes.score_change_path(conn, :edit, score_change))
      assert html_response(conn, 200) =~ "Edit Score change"
    end
  end

  describe "update score_change" do
    setup [:create_score_change]

    test "redirects when data is valid", %{conn: conn, score_change: score_change} do
      conn = put(conn, Routes.score_change_path(conn, :update, score_change), score_change: @update_attrs)
      assert redirected_to(conn) == Routes.score_change_path(conn, :show, score_change)

      conn = get(conn, Routes.score_change_path(conn, :show, score_change))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, score_change: score_change} do
      conn = put(conn, Routes.score_change_path(conn, :update, score_change), score_change: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Score change"
    end
  end

  describe "delete score_change" do
    setup [:create_score_change]

    test "deletes chosen score_change", %{conn: conn, score_change: score_change} do
      conn = delete(conn, Routes.score_change_path(conn, :delete, score_change))
      assert redirected_to(conn) == Routes.score_change_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.score_change_path(conn, :show, score_change))
      end
    end
  end

  defp create_score_change(_) do
    score_change = fixture(:score_change)
    {:ok, score_change: score_change}
  end
end
