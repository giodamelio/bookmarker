defmodule Bookmarker.RedisCase do
  use ExUnit.CaseTemplate

  setup do
    {:ok, _response} = Redix.command(:main, ["FLUSHALL"])
    %{}
  end
end
