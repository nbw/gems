import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :gems, GEMSWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "Fk7lKronuZF1fovYvxWAUDEE4fY82kM+03Eae5nJv7xo5WDrVUtJ0N0rWZPfzZJa",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
