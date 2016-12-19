defmodule LoopedMessage do
  def init do

    __MODULE__
    spawn_link fn -> foo([]) end
  end

  def foo(state) do
    receive do
      msg ->
        new_state = [msg | state]
        IO.inspect new_state
        foo(new_state)
    end
  end
end
