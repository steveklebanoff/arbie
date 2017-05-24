defmodule Arbie.GDaxClient do
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
      IO.puts "GDax Price: #{message["price"]}"
    end
    {:ok, :state}
  end

  def handle_disconnect(reason, state) do
    super(reason, state)
  end
end
