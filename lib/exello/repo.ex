defmodule Exello.Repo do
  use Ecto.Repo,
    otp_app: :exello,
    adapter: Ecto.Adapters.Postgres
end
