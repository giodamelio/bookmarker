# defmodule Bookmarker.Bookmarks do
#   alias Bookmarker.Bookmarks.Bookmark
#   alias Bookmarker.RedisGraph
#   alias Bookmarker.RedisGraph.Cypher

#   @doc """
#   Create a bookmark
#   """
#   def create_bookmark(%Bookmark{} = bookmark) do
#     properties = Cypher.to_cypher(bookmark)

#     RedisGraph.graph_command_single(
#       "CREATE (n:Bookmark #{properties}) RETURN n",
#       :write
#     )
#   end

#   @doc """
#   Get all nodes with the Bookmark label
#   """
#   def get_bookmarks() do
#     RedisGraph.graph_command(~s|MATCH (b:Bookmark) RETURN b|)
#   end

#   @doc """
#   Get a bookmark by it's id
#   """
#   def get_bookmark_by_id(id) do
#     RedisGraph.graph_command_single(~s|MATCH (b:Bookmark) WHERE b.id = "#{id}" RETURN b|)
#   end
# end
