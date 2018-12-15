defmodule DonegoodWeb.Router do
  use DonegoodWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  # see https://evalcode.com/simple-guardian/
  pipeline :browser_auth do
    plug Donegood.Auth.Pipeline
    plug :set_user_as_asset
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/auth", DonegoodWeb do
    pipe_through [:browser]

    get "/sign-in", PageController, :signin
    get "/logout", AuthController, :logout
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :callback
  end


  scope "/", DonegoodWeb do
    pipe_through [:browser, :browser_auth]

    get "/", PageController, :index
    resources "/users", UserController
    resources "/deeds", DeedController do
      resources "/comments", CommentController
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", DonegoodWeb do
  #   pipe_through :api
  # end
  def set_user_as_asset(conn, _) do
    user = conn |> Donegood.Auth.Guardian.Plug.current_resource
    IO.inspect user
    assign(conn, :current_user, user)
  end
end
