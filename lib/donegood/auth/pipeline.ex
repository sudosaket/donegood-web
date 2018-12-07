defmodule Donegood.Auth.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :phoenix_authentication,
    error_handler: Donegood.Auth.ErrorHandler,
    module: Donegood.Auth.Guardian

  plug Guardian.Plug.VerifySession

  plug Guardian.Plug.EnsureAuthenticated

  plug Guardian.Plug.LoadResource
end
