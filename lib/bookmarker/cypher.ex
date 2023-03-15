defmodule Bookmarker.Cypher do
  import Kernel, except: [node: 1]

  def cypher(clauses) when is_list(clauses) do
    if !Keyword.keyword?(clauses) do
      raise "clauses must be a keyword list"
    end

    Enum.map_join(clauses, " ", &cypher/1)
  end

  # CREATE clause
  def cypher({:create, binding}) when is_atom(binding) do
    "CREATE #{node(binding)}"
  end

  def cypher({:create, {binding, labels}}) when is_atom(binding) and is_list(labels) do
    ~s|CREATE #{node({binding, labels})}|
  end

  def cypher({:create, {binding, labels, properties}})
      when is_atom(binding) and is_list(labels) and is_map(properties) do
    ~s|CREATE #{node({binding, labels, properties})}|
  end

  def cypher({:create, {node1, "-", relation, "->", node2}}) do
    ~s|CREATE #{node(node1)}-#{relationship(relation)}->#{node(node2)}|
  end

  def cypher({:create, {node1, "<-", relation, "-", node2}}) do
    ~s|CREATE #{node(node1)}<-#{relationship(relation)}-#{node(node2)}|
  end

  def cypher({:create, nodes}) when is_list(nodes) do
    nodes = Enum.map_join(nodes, ", ", &node/1)
    "CREATE #{nodes}"
  end

  # MATCH clause
  def cypher({:match, binding}) when is_atom(binding) do
    "MATCH #{node(binding)}"
  end

  def cypher({:match, {binding, labels}}) when is_atom(binding) and is_list(labels) do
    ~s|MATCH #{node({binding, labels})}|
  end

  def cypher({:match, {binding, labels, properties}})
      when is_atom(binding) and is_list(labels) and is_map(properties) do
    ~s|MATCH #{node({binding, labels, properties})}|
  end

  # WHERE clause
  def cypher({:where, condition}) when is_binary(condition) do
    "WHERE #{condition}"
  end

  # DELETE clause
  def cypher({:delete, binding}) do
    "DELETE #{binding}"
  end

  # DETACH DELETE clause
  def cypher({:detach_delete, binding}) do
    "DETACH DELETE #{binding}"
  end

  # SET clause
  def cypher({:set, {expression, value}}) do
    "SET #{expression} = #{to_cypher(value)}"
  end

  def cypher({:set, expression}) do
    "SET #{expression}"
  end

  # RETURN clause
  def cypher({:return, bindings}) when is_list(bindings) do
    bindings =
      bindings
      |> Enum.join(", ")

    "RETURN #{bindings}"
  end

  def cypher({:return, binding}), do: cypher({:return, [binding]})

  # ORDER BY clause
  def cypher({:order_by, expressions}) when is_list(expressions) do
    expressions =
      expressions
      |> Enum.join(", ")

    "ORDER BY #{expressions}"
  end

  def cypher({:order_by, expression}), do: cypher({:order_by, [expression]})

  # LIMIT clause
  def cypher({:limit, count}) do
    "LIMIT #{count}"
  end

  # Create a node
  defp node(binding) when is_atom(binding) do
    "(#{binding})"
  end

  defp node({binding, labels}) when is_atom(binding) and is_list(labels) do
    ~s|(#{binding}:#{Enum.join(labels, ":")})|
  end

  defp node({binding, labels, properties})
       when is_atom(binding) and is_list(labels) and is_map(properties) do
    ~s|(#{binding}:#{Enum.join(labels, ":")} #{to_cypher(properties)})|
  end

  # Create a relationship
  defp relationship({binding, label}) do
    ~s|[#{binding}:#{label}]|
  end

  defp relationship({binding, label, properties}) when is_map(properties) do
    ~s|[#{binding}:#{label} #{to_cypher(properties)}]|
  end

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
    |> Enum.map_join(", ", fn {key, value} ->
      if value == nil do
        "null"
      else
        "#{to_string(key)}: #{to_cypher(value)}"
      end
    end)
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
