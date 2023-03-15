defmodule Bookmarker.Cypher do
  def cypher(clauses) when is_list(clauses) do
    Enum.join(clauses, " ")
  end

  # Create a CREATE clause
  def create(clauses) when is_list(clauses) do
    clauses =
      clauses
      |> Enum.map(&string_or_cypher/1)
      |> Enum.join(", ")

    "CREATE #{clauses}"
  end

  def create(clause) do
    "CREATE #{clause}"
  end

  # Create a MATCH clause
  def match(clauses) when is_list(clauses) do
    clauses =
      clauses
      |> Enum.map(&string_or_cypher/1)
      |> Enum.join(", ")

    "MATCH #{clauses}"
  end

  def match(clause) do
    "MATCH #{clause}"
  end

  # Create a RETURN clause
  def return(bindings) when is_list(bindings) do
    "RETURN #{Enum.join(bindings, ", ")}"
  end

  def return(binding) do
    "RETURN #{binding}"
  end

  # Create a node
  def node(binding) do
    "(#{binding})"
  end

  def node(binding, labels) do
    "(#{binding}:#{node_labels(labels)})"
  end

  def node(binding, labels, properties) do
    "(#{binding}:#{node_labels(labels)} #{to_cypher(properties)})"
  end

  # Create a relationship
  def relationship(node1, relation, node2) when is_atom(relation) do
    "#{node1}-[:#{relation}]->#{node2}"
  end

  def relationship(node1, {binding, relation}, node2) when is_atom(relation) do
    "#{node1}-[#{binding}:#{relation}]->#{node2}"
  end

  def relationship(node1, {binding, relation, properties}, node2) when is_atom(relation) do
    "#{node1}-[#{binding}:#{relation} #{to_cypher(properties)}]->#{node2}"
  end

  # Convert one or more labels to a string
  defp node_labels(label) when is_atom(label), do: node_labels([label])

  defp node_labels(labels) when is_list(labels) do
    Enum.join(labels, ":")
  end

  # Convert a value to Cypher if it is not a string
  defp string_or_cypher(data) when is_binary(data), do: data
  defp string_or_cypher(data), do: to_cypher(data)

  # Convert an Elixir value to a Cypher value
  defp to_cypher(data) when is_struct(data) do
    data
    |> Map.from_struct()
    |> to_cypher()
  end

  defp to_cypher(data) when is_map(data) and is_map_key(data, :__meta__) do
    data
    |> Map.delete(:__meta__)
    |> to_cypher()
  end

  defp to_cypher(data) when is_map(data) do
    data
    |> Map.to_list()
    |> Enum.map(fn {key, value} ->
      if value == nil do
        "null"
      else
        "#{to_string(key)}: #{to_cypher(value)}"
      end
    end)
    |> Enum.join(", ")
    |> then(&"{#{&1}}")
  end

  defp to_cypher(data) when is_atom(data) do
    ":#{data}"
  end

  defp to_cypher(data) when is_binary(data) do
    ~s|"#{data}"|
  end

  defp to_cypher(data) do
    to_string(data)
  end
end
