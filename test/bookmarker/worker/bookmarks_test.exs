defmodule Bookmarker.Worker.BookmarksTest do
  use Bookmarker.DataCase

  import Bookmarker.BookmarksFixtures
  alias Bookmarker.Worker.Bookmarks

  setup do
    bookmarker = start_supervised!(Bookmarker.Worker.Bookmarks)
    %{bookmarker: bookmarker}
  end

  test "load/1 properly loads all the edges from the DB", %{bookmarker: b} do
    folder = folder_fixture()
    bookmark1 = bookmark_fixture()
    bookmark2 = bookmark_fixture()

    _edge1 =
      edge_fixture(%{
        v1: "folder_#{folder.id}",
        v2: "bookmark_#{bookmark1.id}",
        label: "parent"
      })

    _edge2 =
      edge_fixture(%{
        v1: "folder_#{folder.id}",
        v2: "bookmark_#{bookmark2.id}",
        label: "parent"
      })

    assert {:ok, 2} = Bookmarks.load(b)
  end
end
