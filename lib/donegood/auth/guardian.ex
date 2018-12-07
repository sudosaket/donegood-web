defmodule Donegood.Auth.Guardian do
  use Guardian, otp_app: :donegood

  alias Donegood.Accounts.User

  def subject_for_token(%User{} = user, _claims) do
    {:ok, to_string(user.id)}
  end

  def resource_from_claims(claims) do
    case claims["sub"] |> Donegood.Accounts.get_user! do
      %User{} = user -> {:ok, user}
      nil -> {:error, :user_not_found}
    end
  end
end
