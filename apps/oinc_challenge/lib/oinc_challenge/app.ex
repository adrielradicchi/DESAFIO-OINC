defmodule OincChallenge.App do
  use Commanded.Application, otp_app: :oinc_challenge

  router(OincChallenge.Router)
end
