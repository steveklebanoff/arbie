defmodule Arbie.StorageTicker do
  use GenServer

  def start_link(_args \\ []) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(state) do
    :timer.send_after(1000, __MODULE__, :tick)
    {:ok, state}
  end

  def handle_info(:tick, state) do
    # do some work
    store_prices()

    :timer.send_after(1000, __MODULE__, :tick)
    {:noreply, state}
  end

  defp store_prices() do
    data = %Arbie.Storage.EthUsd{}

    gdax = GenServer.call(GDaxClient, :status)
    gemini = GenServer.call(GeminiClient, :status)

    data = %{
      data |
      fields: %{data.fields |
        gdax_price: gdax.last_price, gdax_staleness: gdax.staleness,
        gemini_price: gemini.last_price, gemini_staleness: gemini.staleness
      }
    }

    Arbie.Storage.InfluxConnection.write(data)
  end
end
