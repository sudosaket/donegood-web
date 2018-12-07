# Donegood

To start your Phoenix server:

- Install dependencies with `mix deps.get`
- Create and migrate your database with `mix ecto.setup`
- Install Node.js dependencies with `cd assets && npm install`
- Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

# Features

## Primary use cases

- [ ] Michael or Ivanka can log in with... I guess Google?
- [ ] Michael or Ivanka can add and edit and list deeds with a title, score, date and recurrence

## Implementation

Uses Ueberauth to create authenticated users.
Then Guardian protects resources based on the current user.
