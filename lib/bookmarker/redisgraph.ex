defmodule Bookmarker.RedisGraph do
  def redis_command(conn, command) when is_list(command) do
    Redix.command(conn, command)
  end

  def graph_command(conn, db, command) do
    with {:ok, response} <- redis_command(conn, ["GRAPH.QUERY", db, command, "--compact"]) do
      decode(conn, db, response)
    end
  end

  def decode(conn, db, [header, results, _stats]) do
    # Remove deprecated ColumnType entries from the header
    header = Enum.map(header, &Enum.at(&1, 1))

    out =
      for row <- results do
        decode_row(conn, db, row, header)
      end

    {:ok, out}
  end

  def decode_row(conn, db, row, header) do
    # Mix the header name with the column it goes with
    for {header, column} <- Enum.zip(header, row) do
      decode_column(conn, db, column, header)
    end
    |> Map.new()
  end

  def decode_column(conn, db, column, header) do
    {header, decode_value(conn, db, column)}
  end

  # String
  def decode_value(_conn, _db, [2, string]) do
    string
  end

  # Integer
  def decode_value(_conn, _db, [3, num]) do
    String.to_integer(num)
  end

  # Edge
  def decode_value(conn, db, [7, [id, type_id, source_node_id, dest_node_id, properties]]) do
    type = lookup_relationship_types(conn, db, type_id)

    # Decode all the properties of the Edge
    properties =
      Enum.reduce(properties, %{}, fn [property_key_id, value_type, value], props ->
        Map.put(
          props,
          lookup_property_keys(conn, db, property_key_id),
          decode_value(conn, db, [value_type, value])
        )
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
  def decode_value(conn, db, [8, [id, labels, properties]]) do
    labels = Enum.map(labels, &lookup_label(conn, db, &1))

    # Decode all the properties of the Node
    properties =
      Enum.reduce(properties, %{}, fn [property_key_id, value_type, value], props ->
        Map.put(
          props,
          lookup_property_keys(conn, db, property_key_id),
          decode_value(conn, db, [value_type, value])
        )
      end)

    %{
      id: id,
      labels: labels,
      properties: properties
    }
  end

  def decode_value(_conn, _db, [type, value]) do
    throw("Unknown value of type #{type} with a value of #{value}")
  end

  def lookup_label(conn, db, id) do
    generic_lookup(conn, db, "label", "CALL db.labels()", id)
  end

  def lookup_relationship_types(conn, db, id) do
    generic_lookup(conn, db, "relationship_types", "CALL db.relationshipTypes()", id)
  end

  def lookup_property_keys(conn, db, id) do
    generic_lookup(conn, db, "property_keys", "CALL db.propertyKeys()", id)
  end

  def generic_lookup(conn, db, type, call, id) do
    # Create the ETS Named Table if it doesn't exist
    if :ets.whereis(__MODULE__) == :undefined do
      :ets.new(__MODULE__, [:named_table])
    end

    case :ets.lookup(__MODULE__, "#{type}_#{id}") do
      # Do a lookup and save to ETS
      [] ->
        {:ok, [_header, labels, _meta]} = redis_command(conn, ["GRAPH.QUERY", db, call])
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
