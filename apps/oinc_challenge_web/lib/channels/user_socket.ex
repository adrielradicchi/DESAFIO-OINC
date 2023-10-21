defmodule OincChallengepWeb.UserSocket do
  use Phoenix.Socket

  use Absinthe.Phoenix.Socket,
    schema: OincChallengepWeb.Schema

  def connect(params, socket) do
    current_user = current_user(params)

    socket =
      Absinthe.Phoenix.Socket.put_options(socket,
        context: %{
          current_user: current_user
        }
      )

    {:ok, socket}
  end

  defp current_user(%{"user_id" => id}) do
    OincChallenge.Repo.get(OincChallengep.Accounts.Projections.User, id)
  end

  def id(_socket), do: nil
end
