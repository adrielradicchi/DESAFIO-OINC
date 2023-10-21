defmodule OincChallenge.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      OincChallenge.App,
      OincChallenge.Accounts.Supervisor,
      OincChallenge.Repo,
      {DNSCluster, query: Application.get_env(:oinc_challenge, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: OincChallenge.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: OincChallenge.Finch}
      # Start a worker by calling: OincChallenge.Worker.start_link(arg)
      # {OincChallenge.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: OincChallenge.Supervisor)
  end
end
