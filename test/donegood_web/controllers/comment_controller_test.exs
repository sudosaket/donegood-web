defmodule DonegoodWeb.CommentControllerTest do
  use DonegoodWeb.ConnCase

  alias Donegood.Comments

  @create_attrs %{body: "some body", user_id: 1, deed_id: 1}
  @update_attrs %{body: "some updated body"}
  @invalid_attrs %{body: nil}

  def fixture(:comment) do
    {:ok, comment} = Comments.create_comment(@create_attrs)
    comment
  end
  def fixture(:deed) do
    {:ok, deed} = DonegoodWeb.DeedControllerTest.fixture(:deed)
    deed
  end

  describe "new comment" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.deed_comment_path(conn, :new, fixture(:deed)))
      assert html_response(conn, 200) =~ "New Comment"
    end
  end

  describe "create comment" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.deed_comment_path(conn, :create, fixture(:deed)), comment: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.comment_path(conn, :show, id)

      conn = get(conn, Routes.deed_comment_path(conn, :show,fixture(:deed), id))
      assert html_response(conn, 200) =~ "Show Comment"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.deed_comment_path(conn, :create, fixture(:deed)), comment: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Comment"
    end
  end

  describe "edit comment" do
    setup [:create_comment]

    test "renders form for editing chosen comment", %{conn: conn, comment: comment} do
      conn = get(conn, Routes.deed_comment_path(conn, :edit, fixture(:deed), comment))
      assert html_response(conn, 200) =~ "Edit Comment"
    end
  end

  describe "update comment" do
    setup [:create_comment]

    test "redirects when data is valid", %{conn: conn, comment: comment} do
      conn = put(conn, Routes.deed_comment_path(conn, :update, fixture(:deed), comment), comment: @update_attrs)
      assert redirected_to(conn) == Routes.comment_path(conn, :show, comment)

      conn = get(conn, Routes.comment_path(conn, :show, comment))
      assert html_response(conn, 200) =~ "some updated body"
    end

    test "renders errors when data is invalid", %{conn: conn, comment: comment} do
      conn = put(conn, Routes.deed_comment_path(conn, :update, fixture(:deed), comment), comment: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Comment"
    end
  end

  describe "delete comment" do
    setup [:create_comment]

    test "deletes chosen comment", %{conn: conn, comment: comment} do
      conn = delete(conn, Routes.deed_comment_path(conn, :delete, fixture(:deed), comment))
      assert redirected_to(conn) == Routes.comment_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.comment_path(conn, :show, comment))
      end
    end
  end

  defp create_comment(_) do
    comment = fixture(:comment)
    {:ok, comment: comment}
  end
end
