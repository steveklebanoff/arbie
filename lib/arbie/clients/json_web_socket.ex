defmodule JSONWebSocket do

  @doc "Function to create and connect to websocket"
  @callback create_socket() :: Socket.Web
  @doc "Function to receive raw message and store the value"
  @callback process_message(String.t) :: boolean
  @doc "How long to wait to timeout"
  @callback message_timeout() :: integer
  @doc "Name to register module"
  @callback module_name() :: atom

  defmacro __using__(_) do
    quote do
      @behaviour JSONWebSocket

      def start_link() do
        GenServer.start_link(__MODULE__, %{socket: nil, last_price: nil}, [name: module_name()])
      end

      def init(state) do
        # start after 1 second for supervision backoff
        :timer.apply_after(1000, GenServer, :call, [self(), :connect])
        {:ok, state}
      end

      def handle_call(:connect, _from, _state) do
        socket = create_socket()

        # start receving messages in 250 ms
        :timer.apply_after(250, GenServer, :cast, [self(), :next_message])

        {:noreply, %{socket: socket, last_price: nil, last_price_time: nil}}
      end

      def handle_call(:status, _from, state) do
        staleness = Timex.diff(Timex.now, state.last_price_time, :seconds)
        {
          :reply,
          %{last_price: state.last_price, staleness: staleness},
          state
        }
      end

      def handle_cast(:next_message, state) do
        new_price = case state.socket |> Socket.Web.recv!([timeout: message_timeout()]) do
          {:text, data} ->
            found_price = process_message(data)
            GenServer.cast(self(), :next_message)
            found_price
        end
        last_price = if new_price !== nil, do: new_price, else: state.last_price
        last_price_time = if new_price !== nil, do: Timex.now, else: state.last_price_time
        {:noreply, %{socket: state.socket, last_price: last_price, last_price_time: last_price_time}}
      end

      def terminate(_reason, _state) do
        :ok
      end

    end
  end

end
