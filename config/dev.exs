use Mix.Config
config :arbie, Arbie.Storage.InfluxConnection,
  database:  "arbie_dev",
  host:      "localhost",
  auth:      [ username: "admin", password: "admin" ],
  pool:      [ max_overflow: 0, size: 1 ],
  port:      8086,
  scheme:    "http",
  writer:    Instream.Writer.Line
