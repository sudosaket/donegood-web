defmodule DonegoodWeb.UserController do
  use DonegoodWeb, :controller

  alias Donegood.Accounts

  # def index(conn, _params) do
  #   users = Accounts.list_users()
  #   render(conn, "index.html", users: users)
  # end

  # def new(conn, _params) do
  #   changeset = Accounts.change_user(%User{})
  #   render(conn, "new.html", changeset: changeset)
  # end
  #
  # def create(conn, %{"user" => user_params}) do
  #   case Accounts.create_user(user_params) do
  #     {:ok, user} ->
  #       conn
  #       |> put_flash(:info, "User created successfully.")
  #       |> redirect(to: Routes.user_path(conn, :show, user))
  #
  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       render(conn, "new.html", changeset: changeset)
  #   end
  # end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    changeset = Accounts.change_user(user)
    if user.id == conn.assigns.current_user.id do
      render(conn, "edit.html", user: user, changeset: changeset)
    else
      conn
      |> put_flash(:error, "You can't edit that user")
      |> redirect(to: "/")
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)
    if user.id == conn.assigns.current_user.id do
      case Accounts.update_user(user, user_params) do
        {:ok, user} ->
          conn
          |> put_flash(:info, "User updated successfully.")
          |> redirect(to: "/")

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", user: user, changeset: changeset)
      end
    else
      conn
      |> put_flash(:error, "You can't update this user")
      |> redirect(to: "/")
    end
  end

  # def delete(conn, %{"id" => id}) do
  #   user = Accounts.get_user!(id)
  #   {:ok, _user} = Accounts.delete_user(user)
  #
  #   conn
  #   |> put_flash(:info, "User deleted successfully.")
  #   |> redirect(to: Routes.user_path(conn, :index))
  # end


end
