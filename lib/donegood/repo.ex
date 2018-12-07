defmodule Donegood.Repo do
  use Ecto.Repo,
    otp_app: :donegood,
    adapter: Ecto.Adapters.Postgres
end
