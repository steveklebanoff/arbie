defmodule Arbie.Storage do
  import Instream.Query.Builder

  def add_point(exchange, price) do
    data = %Arbie.Storage.PricePoint{}
    data = %{data | fields: %{data.fields | price_point: price}}
    data = %{data | tags:   %{data.tags   | exchange: exchange}}
    Arbie.Storage.InfluxConnection.write(data)
  end

  def get_points do
    Arbie.Storage.PricePoint |> from |> select(["price_point", "exchange"]) |> Arbie.Storage.InfluxConnection.query()
  end
end
