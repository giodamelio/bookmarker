defmodule Bookmarker.RedisGraph do
  @db "main"

  def redis_command(command) when is_list(command) do
    # IO.inspect(command)
    Redix.command(:main, command)
  end

  def graph_command(command) do
    with {:ok, response} = redis_command(["GRAPH.QUERY", @db, command, "--compact"]),
         {:ok, results} = decode(response),
         do: {:ok, results}
  end

  def decode([header, results, _stats]) do
    # Remove deprecated ColumnType entries from the header
    header = Enum.map(header, &Enum.at(&1, 1))

    out =
      for row <- results do
        decode_row(row, header)
      end

    IO.inspect(out)

    {:ok, nil}
  end

  def decode_row(row, header) do
    # Mix the header name with the column it goes with
    for {header, column} <- Enum.zip(header, row) do
      decode_column(column, header)
    end
    |> Map.new()
  end

  def decode_column(column, header) do
    {header, decode_value(column)}
  end

  # String
  def decode_value([2, string]) do
    string
  end

  # Integer
  def decode_value([3, num]) do
    num
  end

  # Edge
  def decode_value([7, [id, type_id, source_node_id, dest_node_id, properties]]) do
    type = lookup_relationship_types(type_id)

    # Decode all the properties of the Edge
    properties =
      Enum.reduce(properties, %{}, fn [property_key_id, value_type, value], props ->
        Map.put(props, lookup_property_keys(property_key_id), decode_value([value_type, value]))
      end)

    %{
      id: id,
      type: type,
      source_node_id: source_node_id,
      dest_node_id: dest_node_id,
      properties: properties
    }
  end

  # Node
  def decode_value([8, [id, labels, properties]]) do
    labels = Enum.map(labels, &lookup_label/1)

    # Decode all the properties of the Node
    properties =
      Enum.reduce(properties, %{}, fn [property_key_id, value_type, value], props ->
        Map.put(props, lookup_property_keys(property_key_id), decode_value([value_type, value]))
      end)

    %{
      id: id,
      labels: labels,
      properties: properties
    }
  end

  def decode_value([type, value]) do
    throw("Unknown value of type #{type} with a value of #{IO.inspect(value)}")
  end

  def lookup_label(id) do
    generic_lookup("label", "CALL db.labels()", id)
  end

  def lookup_relationship_types(id) do
    generic_lookup("relationship_types", "CALL db.relationshipTypes()", id)
  end

  def lookup_property_keys(id) do
    generic_lookup("property_keys", "CALL db.propertyKeys()", id)
  end

  def generic_lookup(type, call, id) do
    # Create the ETS Named Table if it doesn't exist
    if :ets.whereis(__MODULE__) == :undefined do
      :ets.new(__MODULE__, [:named_table])
    end

    case :ets.lookup(__MODULE__, "#{type}_#{id}") do
      # Do a lookup and save to ETS
      [] ->
        {:ok, [_header, labels, _meta]} = redis_command(["GRAPH.QUERY", @db, call])
        label = hd(Enum.at(labels, id))
        :ets.insert(__MODULE__, {"#{type}_#{id}", label})
        label

      # Get label from ETS
      [{_id, label}] ->
        label

      # Should never happen
      _ ->
        raise("More then one #{type} saved for a single ID")
    end
  end
end
