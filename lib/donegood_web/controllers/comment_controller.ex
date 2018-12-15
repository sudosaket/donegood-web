defmodule DonegoodWeb.CommentController do
  use DonegoodWeb, :controller

  alias Donegood.Comments

  alias Donegood.Deeds

  def create(conn, %{"comment" => comment_params, "deed_id" => deed_id}) do
    deed = Deeds.get_deed!(deed_id)
    user_id = conn.assigns.current_user.id
    case Comments.create_comment(
      comment_params
      |> Map.put("user_id", user_id)
      |> Map.put("deed_id", deed_id)
      ) do
      {:ok, comment} ->
        IO.inspect(comment)


        for recipient <- Comments.subscribers_for(deed: deed, except: conn.assigns.current_user ) do
          Donegood.Mailer.deliver_now(
            Donegood.Email.new_comment(
              comment |> Donegood.Repo.preload([:user, :deed]),
              recipient,
              Routes.deed_path(conn, :show, deed)
            )
          )
        end

        conn
        |> put_flash(:info, "Comment created successfully.")
        |> redirect(to: Routes.deed_path(conn, :show, deed))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:error, inspect(changeset))
        |> redirect(to: Routes.deed_path(conn, :show, deed))

    end
  end

  def show(conn, %{"id" => id}) do
    comment = Comments.get_comment!(id)
    render(conn, "show.html", comment: comment)
  end

  def edit(conn, %{"id" => id}) do
    comment = Comments.get_comment!(id)
    changeset = Comments.change_comment(comment)
    render(conn, "edit.html", comment: comment, changeset: changeset)
  end

  def update(conn, %{"id" => id, "comment" => comment_params, "deed" => deed_params}) do
    deed = Deeds.get_deed!(deed_params["id"])
    comment = Comments.get_comment!(id)

    case Comments.update_comment(comment, comment_params) do
      {:ok, comment} ->
        conn
        |> put_flash(:info, "Comment updated successfully.")
        |> redirect(to: Routes.deed_comment_path(conn, :show, deed, comment))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", comment: comment, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id, "deed" => deed_params}) do
    deed = Deeds.get_deed!(deed_params["id"])

    comment = Comments.get_comment!(id)
    {:ok, _comment} = Comments.delete_comment(comment)

    conn
    |> put_flash(:info, "Comment deleted successfully.")
    |> redirect(to: Routes.deed_path(conn, :index, deed))
  end
end
