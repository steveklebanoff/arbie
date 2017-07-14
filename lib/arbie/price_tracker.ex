defmodule Arbie.PriceTracker do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, %{
        eth_usd: %{
          gemini: %{last_price: nil, last_price_time: nil},
          gdax: %{last_price: nil, last_price_time: nil},
        }
    }, name: PriceTracker)
  end

  def track(currency_pair, exchange, last_price, last_price_time) do
    GenServer.call(
      PriceTracker, {:track, currency_pair, exchange, last_price, last_price_time}
    )

    {:ok, currency_pair, exchange, last_price, last_price_time}
  end

  def get(currency_pair, exchange) do
    result = GenServer.call(
      PriceTracker, {:status, currency_pair, exchange}
    )

    if result == nil, do: {:error, "exchange not found"}, else: {:ok, result}
  end

  def handle_call({:status, currency_pair, exchange}, _from, state) do
    {:reply, Kernel.get_in(state, [currency_pair, exchange]), state}
  end

  def handle_call(
    {:track, currency_pair, exchange, last_price, last_price_time},
    _from, state
  ) do
    new_state = Kernel.put_in(
      state,
      [currency_pair, exchange],
      %{last_price: last_price, last_price_time: last_price_time}
    )
    {:reply, new_state, new_state}
  end

end
