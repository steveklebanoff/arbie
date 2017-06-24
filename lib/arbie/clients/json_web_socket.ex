defmodule JSONWebSocket do

  @doc "Function to create and connect to websocket"
  @callback create_socket() :: Socket.Web
  @doc "Function to receive raw message and store the value"
  @callback process_message(string) :: boolean
  @doc "How long to wait to timeout"
  @callback message_timeout() :: integer

  defmacro __using__(_) do
    quote do
      @behaviour JSONWebSocket

      def start_link() do
        GenServer.start_link(__MODULE__, %{})
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

        {:noreply, %{socket: socket, last: "none"}}
      end

      def handle_call(:status, _from, state) do
        {:reply, state, state}
      end

      def handle_cast(:next_message, state) do
        new_price = nil
        case state.socket |> Socket.Web.recv!([timeout: message_timeout()]) do
          {:text, data} ->
            new_price = process_message(data)
            GenServer.cast(self(), :next_message)
        end
        last = if new_price !== nil, do: new_price, else: state.last
        {:noreply, %{socket: state.socket, last: last}}
      end

      def terminate(_reason, _state) do
        :ok
      end

    end
  end

end
