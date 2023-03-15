defmodule Bookmarker.LinkTest do
  use Bookmarker.RedisCase

  alias Bookmarker.RedisGraph

  @db "main"

  describe "graph_command/2" do
    test "simple node creation", %{redis_conn: conn} do
      {:ok, [result]} =
        RedisGraph.graph_command(conn, @db, "CREATE (p:Person {name:'Kirsten'}) RETURN p")

      assert result["p"].properties["name"] == "Kirsten"
    end
  end
end
