# Arbie

Grabs prices from cryptocurrency exchanges, stores in InfluxDB.

Currently supports GDax and Gemini ETH/USD prices.

Generates data every 500ms in the following format:

``
name: eth_usd
time                           gdax_price gdax_staleness_ms gemini_price gemini_staleness_ms percent_diff
2017-07-14T06:38:36.238413431Z 200.99     17265             201.7        1917                0.3532514055425541
2017-07-14T06:38:35.730929882Z 200.99     16757             201.7        1409                0.3532514055425541
2017-07-14T06:38:35.221833376Z 200.99     16248             201.7        900                 0.3532514055425541
2017-07-14T06:38:34.718793024Z 200.99     15745             201.7        397                 0.3532514055425541
2017-07-14T06:38:34.21629872Z  200.99     15243             202.2        20784               0.6020200009950641
2017-07-14T06:38:33.70887319Z  200.99     14735             202.2        20276               0.6020200009950641
```

`staleness` represents the ms since the data was reported from the exchange
`percent_diff` shows the % difference between the two exchanges

# Setting up locally

- Install InfluxDB
- Create admin user locally

```
influx
CREATE USER admin WITH PASSWORD 'admin' WITH ALL PRIVILEGES
```
- Enable auth on influxdb (See Step 2 on https://docs.influxdata.com/influxdb/v1.2/query_language/authentication_and_authorization/#set-up-authentication)
- Now to run `influx` you must specify `-username` and `-password`
- Create database and retention policy

```
influx -username admin -password admin
CREATE DATABASE arbie_dev
CREATE RETENTION POLICY "forever" ON "arbie_dev" DURATION INF REPLICATION 1
```

Run `iex -S mix` and you should see prices being stored.

# Acknowledgements

Thanks [redcap3000/crypto-socket](https://github.com/redcap3000/crypto-socket) for some good examples!

# Releasing
- `mix release.init`
- set up config in `rel/config.exs`
- `mix release`
