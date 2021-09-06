# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :todo_live,
  ecto_repos: [TodoLive.Repo]

# Configures the endpoint
config :todo_live, TodoLiveWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "o2Y9OI9pWmrvLtA/5urkLvSZFnvbZF/id4zpFr8svkGo0yVlB2cMUyE8sk/Xkvlx",
  render_errors: [view: TodoLiveWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: TodoLive.PubSub,
  live_view: [signing_salt: "YPd9jeXX"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :todo_live, TodoLive.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.12.18",
  default: [
    args: ~w(js/app.js --bundle --target=es2016 --outdir=../priv/static/assets),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
