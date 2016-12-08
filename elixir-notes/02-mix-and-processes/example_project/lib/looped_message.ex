defmodule LoopedMessage do
  def init do
    spawn_link fn -> loop([]) end
  end

  def loop(state) do
    receive do
      msg ->
        state = [msg | state]
        IO.inspect state
      loop(state)
    end
  end
end
