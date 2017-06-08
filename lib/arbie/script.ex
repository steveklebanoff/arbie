defmodule Arbie.Script do
  def main(_args) do
    # TODO: got to be a better way to creating a long running process
    IO.puts "Starting arbie..."

    receive do
      {msg} -> IO.puts "Received #{msg}"
    end


  end
end
