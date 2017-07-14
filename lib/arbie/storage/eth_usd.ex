defmodule Arbie.Storage.EthUsd do
  use Instream.Series

  series do
    measurement "eth_usd"
    field :gdax_price
    field :gdax_staleness_ms
    field :gemini_price
    field :gemini_staleness_ms
  end
end
