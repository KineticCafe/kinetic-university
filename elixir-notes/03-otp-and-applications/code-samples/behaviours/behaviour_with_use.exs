defmodule Parser do
  @callback parse(String.t) :: map
  @callback extensions() :: [String.t]

  defmacro __using__(_opts) do
    quote do
      @behaviour Parser

      # Add a parser that returns an empty map by default
      def parse(str) do
        %{}
      end

      defoverridable [parse: 1]
    end
  end
end


defmodule JSONParser do
  use Parser

  def parse(str), do: # ... parse JSON
  def extensions, do: ["json"]
end


defmodule YAMLParser do
  use Parser

  def parse(str), do: # ... parse YAML
  def extensions, do: ["yml"]
end


defmodule UselessParser do
  use Parser

  def extensions, do: ["bmp"]
end
