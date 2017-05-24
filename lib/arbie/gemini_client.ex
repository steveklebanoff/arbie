defmodule Arbie.GeminiClient do
  use WebSockex.Client
  require Logger

  def start_link do
    WebSockex.Client.start_link("wss://api.gemini.com/v1/marketdata/ethusd", __MODULE__, :state)
  end

  def handle_frame({:text, json_encoded_message}, :state) do
    message = Poison.decode!(json_encoded_message)
    if (message["events"]) do
      event = Enum.fetch!(message["events"], 0)
      if (event["type"] == "trade") do
        IO.puts "Gemini Price: #{event["price"]}"
      end
    end
    {:ok, :state}
  end

  def handle_disconnect(reason, state) do
    super(reason, state)
  end
end
