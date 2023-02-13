defmodule Bookmarker.RedisgraphTest do
  use ExUnit.Case, async: true

  alias Bookmarker.RedisGraph

  describe "item_array_to_map/1" do
    test "convert a item array to a map" do
      item_array = [["a", "b"], ["b", 1]]
      assert RedisGraph.item_array_to_map(item_array) == %{a: "b", b: 1}
    end
  end

  describe "to_cypher/1" do
    test "basic map" do
      assert RedisGraph.to_cypher(%{aaa: "bbb", ccc: "ddd"}) == ~S|{ aaa: "bbb", ccc: "ddd" }|
    end
  end
end
