defmodule DonegoodWeb.DeedView do
  use DonegoodWeb, :view

  def users_select_list do
    Donegood.Repo.all(Donegood.Accounts.User) |> Enum.map(&{&1.name, &1.id})
  end
end
