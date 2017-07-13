defmodule Arbie.Storage.EthUsd do
  use Instream.Series

  series do
    measurement "eth_usd"
    field :gdax_price
    field :gdax_staleness
    field :gemini_price
    field :gemini_staleness
  end
end
