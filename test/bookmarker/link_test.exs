defmodule Bookmarker.LinkTest do
  use Bookmarker.RedisCase

  alias Bookmarker.Link

  describe "create/1" do
    test "create a link node" do
      link = Link.create(%{title: "Reddit", url: "https://reddit.com"})

      assert link.title == "Reddit"
      assert link.url == "https://reddit.com"
    end
  end
end
