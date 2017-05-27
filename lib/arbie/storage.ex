defmodule Arbie.Storage do
  import Instream.Query.Builder

  def add_point(exchange, price) do
    data = %Arbie.PricePoint{}
    data = %{data | fields: %{data.fields | price_point: price}}
    data = %{data | tags:   %{data.tags   | exchange: exchange}}
    Arbie.InfluxConnection.write(data)
  end

  def get_points do
    Arbie.PricePoint |> from |> select(["price_point", "exchange"]) |> Arbie.InfluxConnection.query()
  end
end
