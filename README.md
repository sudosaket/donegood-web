# Donegood
This app uses Elixir and Phoenix. Learn more about the framework [here](https://phoenixframework.org).

To start the server:
- Install dependencies with `mix deps.get`
- Create and migrate your database with `mix ecto.setup`
- Install Node.js dependencies with `cd assets && npm install`
- Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4015`](http://localhost:4015) from your browser.

# Roadmap
See [projects](https://github.com/grandpodcast/donegood-web/projects).


## Implementation

Uses Ueberauth to create authenticated users.
Then Guardian protects resources based on the current user.
