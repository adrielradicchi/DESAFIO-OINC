import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :oinc_challenge, OincChallenge.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "oinc_challenge_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :oinc_challenge_web, OincChallengeWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "UAvKQ5Tr7abR/Z805fG9EbLw0c9v0Is2w8pKVt2SOKQE38Cog6hrxPMx14FwXCuS",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# In test we don't send emails.
config :oinc_challenge, OincChallenge.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
