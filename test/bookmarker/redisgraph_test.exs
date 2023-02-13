defmodule Bookmarker.RedisgraphTest do
  use ExUnit.Case

  alias Bookmarker.RedisGraph

  describe "decode/1" do
    test "basic decode" do
      # {:ok, result} = RedisGraph.graph_command("MATCH (b:Bookmark) RETURN b, 10 as num")
      {:ok, result} =
        RedisGraph.graph_command("MATCH (a)-[e]->(b) RETURN a, e, b.name as fruit_name")

      assert result == nil
    end
  end

  # describe "to_cypher/1" do
  #   test "basic map" do
  #     assert RedisGraph.to_cypher(%{aaa: "bbb", ccc: "ddd"}) == ~S|{ aaa: "bbb", ccc: "ddd" }|
  #   end
  # end
end
