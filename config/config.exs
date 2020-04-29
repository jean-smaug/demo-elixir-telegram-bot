use Mix.Config

config :tesla, adapter: Tesla.Adapter.Hackney

config :ex_gram,
  # TODO: replace this invalid token,
  token: "1287038449:AAHvSU4cGipZUH6i2Pbbhiz9akkE7_wP4YQ",
  adapter: ExGram.Adapter.Tesla,
  json_engine: Jason
