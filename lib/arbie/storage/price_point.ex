defmodule Arbie.Storage.PricePoint do
  use Instream.Series

  series do
    measurement "prices"

    tag :exchange

    field :price_point
  end
end
