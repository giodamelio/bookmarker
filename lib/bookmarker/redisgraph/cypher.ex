defmodule Bookmarker.Redisgraph.Cypher do
  def to_cypher(data) when is_struct(data) do
    data
    |> Map.from_struct()
    |> to_cypher()
  end

  def to_cypher(data) when is_map(data) do
    data
    |> Map.to_list()
    |> Enum.map(fn {key, value} ->
      "#{to_string(key)}: #{to_cypher(value)}"
    end)
    |> Enum.join(", ")
    |> then(&"{ #{&1} }")
  end

  def to_cypher(data) when is_binary(data) do
    ~s|"#{data}"|
  end

  def to_cypher(data) do
    to_string(data)
  end
end
