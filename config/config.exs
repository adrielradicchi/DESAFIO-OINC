# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

# Configure Mix tasks and generators
config :oinc_challenge,
  ecto_repos: [OincChallenge.Repo]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :oinc_challenge, OincChallenge.Mailer, adapter: Swoosh.Adapters.Local

config :oinc_challenge_web,
  ecto_repos: [OincChallenge.Repo],
  generators: [context_app: :oinc_challenge, binary_id: true]

# Configures the endpoint
config :oinc_challenge_web, OincChallengeWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Phoenix.Endpoint.Cowboy2Adapter,
  render_errors: [
    formats: [html: OincChallengeWeb.ErrorHTML, json: OincChallengeWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: OincChallenge.PubSub,
  live_view: [signing_salt: "7zA0YeeG"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../apps/oinc_challenge_web/assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.3.2",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../apps/oinc_challenge_web/assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :commanded, default_consistency: :strong

config :commanded, dispatch_consistency_timeout: 10_000

config :commanded, include_execution_result: true

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :oinc_challenge, OincChallenge.App,
  event_store: [
    adapter: Commanded.EventStore.Adapters.EventStore,
    event_store: OincChallenge.EventStore
  ],
  pubsub: [
    phoenix_pubsub: [
      adapter: Phoenix.PubSub.PG2,
      pool_size: 1
    ]
  ]

# registry: :local

config :commanded_ecto_projections, repo: OincChallenge.Repo

config :oinc_challenge, event_stores: [OincChallenge.EventStore]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
