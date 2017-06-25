# Arbie

Grabs prices from cryptocurrency exchanges, stores in InfluxDB.

Currently supports GDax and Gemini ETH/USD prices.

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
