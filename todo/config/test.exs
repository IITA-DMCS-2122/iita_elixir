import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :todo, Todo.Repo,
  username: "olrgsemzyzxyfr",
  password: "eb1ed57e8321136a4d1d4964d8a65b260e329b64ef9ee3c63a5807c733d3fd4d",
  hostname: "ec2-34-246-24-110.eu-west-1.compute.amazonaws.com",
  database: "d95dt5ftbekr6g",
  maintenance_database: "d95dt5ftbekr6g",
  ssl: true,
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :todo, TodoWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "qxSY4a3OLt3RMx2rE2bk2T6QTF8iTPyT1rixJBGR/I0zH7Ax4EjTmXBbvTSCf6eS",
  server: false

# In test we don't send emails.
config :todo, Todo.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
