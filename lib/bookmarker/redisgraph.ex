defmodule Bookmarker.RedisGraph do
  def redis_command(command) when is_list(command) do
    IO.inspect(command)
    Redix.command(:main, command)
  end

  def graph_command(command) do
    command = redis_command(["GRAPH.RO_QUERY", "main", command])

    case command do
      {:ok, response} -> {:ok, parse_response(response)}
      {:error, response} -> {:error, response}
    end
  end

  def graph_command(command, :write) do
    command = redis_command(["GRAPH.QUERY", "main", command])

    case command do
      {:ok, response} -> {:ok, parse_response(response)}
      {:error, response} -> {:error, response}
    end
  end

  def graph_command_single(command) do
    command = redis_command(["GRAPH.RO_QUERY", "main", command])

    case command do
      {:ok, response} -> {:ok, parse_response_single(response)}
      {:error, response} -> {:error, response}
    end
  end

  def graph_command_single(command, :write) do
    command = redis_command(["GRAPH.QUERY", "main", command])

    case command do
      {:ok, response} -> {:ok, parse_response_single(response)}
      {:error, response} -> {:error, response}
    end
  end

  def parse_response([_header, [], _meta]) do
    nil
  end

  def parse_response([header, [data], _meta]) do
    transformed_data = Enum.map(data, &parse_response_item/1)

    header
    |> Enum.zip(transformed_data)
    |> Map.new()
  end

  def parse_response([header, data, meta]) do
    data
    |> tap(&IO.inspect/1)
    |> Enum.map(&parse_response([header, &1, meta]))
  end

  def parse_response_single([_header, [], _meta] = response) do
    parse_response(response)
  end

  def parse_response_single(response) do
    parse_response(response)
    |> Map.values()
    |> hd()
  end

  def parse_response_item(data) do
    data
    |> item_array_to_map()
    |> then(fn item ->
      Map.update!(item, :properties, &item_array_to_map/1)
    end)
  end

  def item_array_to_map(data) do
    data
    |> Enum.map(&List.to_tuple/1)
    |> Enum.map(fn {key, value} -> {String.to_atom(key), value} end)
    |> Map.new()
  end

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
