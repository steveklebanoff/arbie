defmodule Arbie.Clients.GDax do
  use JSONWebSocket
  def message_timeout(), do: 1000
  def module_name(), do: GDaxClient

  def create_socket do
    IO.puts "GDAX: Connecting"
    socket = Socket.Web.connect! "ws-feed.gdax.com", secure: true

    message = Poison.encode!(%{type: "subscribe", product_ids: ["ETH-USD"]})
    Socket.Web.send!(socket, {:text, message})

    IO.puts "GDAX: Connected"
    socket
  end

  def process_message(raw_data) do
    message = Poison.decode!(raw_data)
    if message["type"] == "match" do
      {price, _} = Float.parse(message["price"])
      IO.puts "GDAX: Price #{price}"
      price
    end
  end
end
