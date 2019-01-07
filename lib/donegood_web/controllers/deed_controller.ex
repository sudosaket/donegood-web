defmodule DonegoodWeb.DeedController do
  use DonegoodWeb, :controller

  alias Donegood.Deeds
  alias Donegood.Deeds.Deed
  alias Donegood.Comments
  alias Donegood.Comments.Comment
  import Phoenix.HTML.Link


  plug Guardian.Plug.EnsureAuthenticated

  def index(conn, _params) do
    deeds = Deeds.list_deeds()
    render(conn, "index.html", deeds: deeds)
  end

  def new(conn, _params) do
    changeset = Deed.changeset(%Deed{},%{
      when: Date.utc_today,
      repeats: false,
      user_id: conn.assigns.current_user.id
    })
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"deed" => deed_params}) do
    user = conn.assigns[:current_user]
    deed = deed_params |> Map.merge(%{"created_by_user_id" => Kernel.inspect(user.id)})

    case Deeds.create_deed(deed) do
      {:ok, _deed} ->
        conn
        |> put_flash(:info, [
          "Deed created successfully. ",
          link("Add another?", to: Routes.deed_path(conn, :new))
          ])
        |> redirect(to: "/")

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.puts("Failed to create deed with")
        IO.inspect(deed)
        IO.puts("result")
        IO.inspect(changeset)
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    deed = Deeds.get_deed!(id)
    new_comment = Comments.change_comment(%Comment{})
    comments = Comments.list_comments(deed)

    discussion = (
       Enum.map(comments, fn comment -> {:comment, comment} end )
        ++ Enum.map(deed.score_changes, fn score_change -> {:score_change, score_change} end )
      )
      |> Enum.sort_by(fn {_, item} -> item.inserted_at end )
    render(conn, "show.html", deed: deed, new_comment: new_comment, discussion: discussion)
  end

  def edit(conn, %{"id" => id}) do
    deed = Deeds.get_deed!(id)
    changeset = Deeds.change_deed(deed)
    render(conn, "edit.html", deed: deed, changeset: changeset)
  end

  def update(conn, %{"id" => id, "deed" => deed_params}) do
    deed = Deeds.get_deed!(id)

    if editable_by_current_user?(conn, deed) do
      case Deeds.update_deed(deed, deed_params, conn.assigns.current_user) do
        {:ok, deed} ->
          conn
          |> put_flash(:info, "Deed updated successfully.")
          |> redirect(to: Routes.deed_path(conn, :show, deed))

        {:error, %Ecto.Changeset{} = changeset} ->
          IO.puts("Failed to update deed with")
          IO.inspect(deed)
          IO.puts("result")
          IO.inspect(changeset)
          render(conn, "edit.html", deed: deed, changeset: changeset)
      end
    else
      conn |> put_flash(:error, "You are not allowed to edit this") |> redirect(to: Routes.deed_path(conn, :show, deed))
    end

  end

  def delete(conn, %{"id" => id}) do
    deed = Deeds.get_deed!(id)
    if editable_by_current_user?(conn,deed) do
      {:ok, _deed} = Deeds.delete_deed(deed)
      conn
      |> put_flash(:info, "Deed deleted successfully.")
      |> redirect(to: Routes.deed_path(conn, :index))
    else
      conn
      |> put_flash(:error, "You are not allowed to delete this")
      |> redirect(to: Routes.deed_path(conn, :index))
    end

  end


  def editable_by_current_user?(conn, deed) do
    current_user_id = conn.assigns.current_user.id
    current_user_id == deed.user_id or current_user_id == deed.created_by_user_id
  end
end
