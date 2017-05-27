defmodule Arbie.Clients.GDax do
  use WebSockex.Client
  require Logger

  def start_link do
    {:ok, pid} = WebSockex.Client.start_link("wss://ws-feed.gdax.com/", __MODULE__, :state)
    message = Poison.encode!(%{type: "subscribe", product_ids: ["ETH-USD"]})
    WebSockex.Client.send_frame(pid, {:text, message})
  end

  def handle_frame({:text, json_encoded_message}, :state) do
    message = Poison.decode!(json_encoded_message)
    if message["type"] == "match" do
      {parsed_price, _} = Float.parse(message["price"])
      store_price(parsed_price)
    end
    {:ok, :state}
  end

  def handle_disconnect(reason, state) do
    super(reason, state)
  end

  defp store_price(price) do
    IO.puts "GDax Price: #{price}"
    Arbie.Storage.add_point("gdax", price)
  end
end
