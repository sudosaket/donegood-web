defmodule DonegoodWeb.DeedControllerTest do
  use DonegoodWeb.ConnCase

  alias Donegood.Deeds

  @create_attrs %{score: 42, title: "some title", when: ~D[2010-04-17], user_id: 1, created_by_user_id: 1}
  @update_attrs %{score: 43, title: "some updated title", when: ~D[2011-05-18]}
  @invalid_attrs %{score: nil, title: nil, when: nil}

  setup do
    {conn, _user} = build_conn() |> with_valid_user()
    {:ok, conn: conn}
  end

  def fixture(:deed) do
    {:ok, deed} = Deeds.create_deed(@create_attrs)
    deed
  end

  describe "index" do
    test "lists all deeds", %{conn: conn} do
      conn = get(conn, Routes.deed_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Deeds"
    end
  end

  describe "new deed" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.deed_path(conn, :new))
      assert html_response(conn, 200) =~ "New Deed"
    end
  end

  describe "create deed" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.deed_path(conn, :create), deed: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.deed_path(conn, :show, id)

      conn = get(conn, Routes.deed_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Deed"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.deed_path(conn, :create), deed: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Deed"
    end
  end

  describe "edit deed" do
    setup [:create_deed]

    test "renders form for editing chosen deed", %{conn: conn, deed: deed} do
      conn = get(conn, Routes.deed_path(conn, :edit, deed))
      assert html_response(conn, 200) =~ "Edit Deed"
    end
  end

  describe "update deed" do
    setup [:create_deed]

    test "redirects when data is valid", %{conn: conn, deed: deed} do
      conn = put(conn, Routes.deed_path(conn, :update, deed), deed: @update_attrs)
      assert redirected_to(conn) == Routes.deed_path(conn, :new)

      conn = get(conn, Routes.deed_path(conn, :show, deed))
      assert html_response(conn, 200) =~ "some updated title"
    end

    test "renders errors when data is invalid", %{conn: conn, deed: deed} do
      conn = put(conn, Routes.deed_path(conn, :update, deed), deed: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Deed"
    end
  end

  describe "delete deed" do
    setup [:create_deed]

    test "deletes chosen deed", %{conn: conn, deed: deed} do
      conn = delete(conn, Routes.deed_path(conn, :delete, deed))
      assert redirected_to(conn) == Routes.deed_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.deed_path(conn, :show, deed))
      end
    end
  end

  defp create_deed(_) do
    deed = fixture(:deed)
    {:ok, deed: deed}
  end
end
