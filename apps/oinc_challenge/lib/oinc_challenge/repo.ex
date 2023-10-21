defmodule OincChallenge.Repo do
  use Ecto.Repo,
    otp_app: :oinc_challenge,
    adapter: Ecto.Adapters.Postgres
end
