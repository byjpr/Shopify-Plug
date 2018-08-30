use Mix.Config

case Mix.env() do
  :test -> config :logger, level: :error
  _ -> config :logger, level: :info
end
