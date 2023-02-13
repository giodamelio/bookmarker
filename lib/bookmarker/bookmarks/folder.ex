defmodule Bookmarker.Bookmarks.Folder do
  @enforce_keys [:id, :title]
  defstruct [:id, :title]

  def new(%{} = attrs) do
    attrs
    |> Map.put_new_lazy(:id, &Ecto.UUID.generate/0)
    |> then(&struct!(__MODULE__, &1))
  end
end
