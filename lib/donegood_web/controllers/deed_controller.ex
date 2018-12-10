defmodule DonegoodWeb.DeedController do
  use DonegoodWeb, :controller

  alias Donegood.Deeds
  alias Donegood.Deeds.Deed

  plug Guardian.Plug.EnsureAuthenticated

  def index(conn, _params) do
    deeds = Deeds.list_deeds()
    render(conn, "index.html", deeds: deeds)
  end

  def new(conn, _params) do
    changeset = Deed.changeset(%Deed{},%{
      when: Date.utc_today,
      repeats: false
    })
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"deed" => deed_params}) do
    user = conn.assigns[:current_user]
    deed = deed_params |> Map.merge(%{"created_by_user_id" => user.id})

    case Deeds.create_deed(deed) do
      {:ok, _deed} ->
        conn
        |> put_flash(:info, "Deed created successfully. Add another?")
        |> redirect(to: Routes.deed_path(conn, :new))

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.puts("Failed to created deed with")
        IO.inspect(deed)
        IO.puts("result")
        IO.inspect(changeset)
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    deed = Deeds.get_deed!(id)
    render(conn, "show.html", deed: deed)
  end

  def edit(conn, %{"id" => id}) do
    deed = Deeds.get_deed!(id)
    ensure_editable_by_current_user!(conn,deed)
    changeset = Deeds.change_deed(deed)
    render(conn, "edit.html", deed: deed, changeset: changeset)
  end

  def update(conn, %{"id" => id, "deed" => deed_params}) do
    deed = Deeds.get_deed!(id)
    ensure_editable_by_current_user!(conn,deed)
    case Deeds.update_deed(deed, deed_params) do
      {:ok, deed} ->
        conn
        |> put_flash(:info, "Deed updated successfully.")
        |> redirect(to: Routes.deed_path(conn, :show, deed))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", deed: deed, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    deed = Deeds.get_deed!(id)
    ensure_editable_by_current_user!(conn,deed)
    {:ok, _deed} = Deeds.delete_deed(deed)

    conn
    |> put_flash(:info, "Deed deleted successfully.")
    |> redirect(to: Routes.deed_path(conn, :index))
  end


  def ensure_editable_by_current_user!(conn, deed) do
    current_user_id = conn.assigns.current_user.id
    if (current_user_id != deed.user_id and current_user_id != deed.created_by_user_id) do
      conn
      |> Phoenix.Controller.put_flash(:error, "Not your deed")
      |> halt()
    end
  end
end
