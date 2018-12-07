defmodule DonegoodWeb.DeedController do
  use DonegoodWeb, :controller

  alias Donegood.Deeds
  alias Donegood.Deeds.Deed

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

    case Deeds.create_deed(deed_params |> Map.merge(%{"user_id" => user.id})) do
      {:ok, deed} ->
        conn
        |> put_flash(:info, "Deed created successfully.")
        |> redirect(to: Routes.deed_path(conn, :show, deed))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    deed = Deeds.get_deed!(id)
    render(conn, "show.html", deed: deed)
  end

  def edit(conn, %{"id" => id}) do
    deed = Deeds.get_deed!(id)
    changeset = Deeds.change_deed(deed)
    render(conn, "edit.html", deed: deed, changeset: changeset)
  end

  def update(conn, %{"id" => id, "deed" => deed_params}) do
    deed = Deeds.get_deed!(id)

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
    {:ok, _deed} = Deeds.delete_deed(deed)

    conn
    |> put_flash(:info, "Deed deleted successfully.")
    |> redirect(to: Routes.deed_path(conn, :index))
  end
end
