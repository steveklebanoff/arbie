defmodule Arbie.StorageTicker do
  @tick_time 500
  use GenServer

  def start_link(_args \\ []) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(state) do
    :timer.send_after(@tick_time, __MODULE__, :tick)
    {:ok, state}
  end

  def handle_info(:tick, state) do
    # do some work
    store_prices()

    :timer.send_after(@tick_time, __MODULE__, :tick)
    {:noreply, state}
  end

  defp store_prices() do
    data = %Arbie.Storage.EthUsd{}

    {:ok, gdax} = Arbie.PriceTracker.get(:eth_usd, :gdax)
    gdax_price = gdax.last_price
    gdax_staleness = get_staleness(gdax.last_price_time)

    {:ok, gemini} = Arbie.PriceTracker.get(:eth_usd, :gemini)
    gemini_price = gemini.last_price
    gemini_staleness = get_staleness(gemini.last_price_time)

    data = %{
      data |
      fields: %{data.fields |
        gdax_price: gdax_price, gdax_staleness_ms: gdax_staleness,
        gemini_price: gemini_price, gemini_staleness_ms: gemini_staleness
      }
    }

    Arbie.Storage.InfluxConnection.write(data)
  end

  defp get_staleness(nil) do
    nil
  end

  defp get_staleness(time) do
    Timex.diff(Timex.now, time, :milliseconds)
  end
end
