defmodule Bookmarker.Repo do
  use Ecto.Repo,
    otp_app: :bookmarker,
    adapter: Ecto.Adapters.SQLite3
end
