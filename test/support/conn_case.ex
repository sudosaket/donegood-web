defmodule DonegoodWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      alias DonegoodWeb.Router.Helpers, as: Routes

      import DonegoodWeb.ConnCase, only: [with_user: 2, with_valid_user: 1]

      # The default endpoint for testing
      @endpoint DonegoodWeb.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Donegood.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Donegood.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

  def with_user(conn, user) do
    import Donegood.Auth.Guardian
    import Plug.Conn

    {:ok, token, _} = encode_and_sign(user, %{}, token_type: :access)
    conn =
      conn
      |> put_req_header("authorization", "bearer: " <> token)
      |> Map.put(:assigns, %{current_user: user})

    {conn, user}
  end

  def with_valid_user(conn) do
    user =
      %Donegood.Accounts.User{
        id: 1,
        name: "Michael Forrest"
      }
      |> Donegood.Repo.insert!

    with_user(conn, user)
  end
end
