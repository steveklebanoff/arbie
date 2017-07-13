defmodule Arbie.Clients.Gemini do
  use JSONWebSocket
  def message_timeout(), do: 10_000
  def module_name(), do: GeminiClient

  def create_socket do
    IO.puts "Gemini: Connecting"
    socket = Socket.Web.connect! "api.gemini.com", path: "/v1/marketdata/ethusd", secure: true
    IO.puts "Gemini: Connected"
    socket
  end

  def process_message(raw_data) do
    message = Poison.decode!(raw_data)
    if message["events"] do
      event = Enum.fetch!(message["events"], 0)
      if event["type"] == "trade" do
        {price, _} = Float.parse(event["price"])
        IO.puts "Gemini Price: #{price}"
        Arbie.Storage.add_point("gemini", price)
        price
      end
    end
  end
end
