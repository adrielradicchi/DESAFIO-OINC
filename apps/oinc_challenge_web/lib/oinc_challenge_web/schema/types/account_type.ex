defmodule OincChallengeWeb.Schema.Types.AccountType do
  use Absinthe.Schema.Notation

  alias OincChallengeWeb.Schema.Resolvers.AccountResolver
  alias Crudry.Middlewares.TranslateErrors

  object :account_mutation do
    field :open_account, :account do
      arg(:user_name, non_null(:string), description: "User name")
      arg(:goal_name, non_null(:string), description: "Goal name")
      arg(:initial_balance, non_null(:integer), description: "Initial balance")

      resolve(&AccountResolver.open_account/2)
      middleware(TranslateErrors)
    end

    field :close_account, :account do
      arg(:id, non_null(:string))
      resolve(&AccountResolver.close_account/2)
      middleware(TranslateErrors)
    end

    field :deposit, :account do
      arg(:id, non_null(:string))
      arg(:amount, non_null(:integer))
      resolve(&AccountResolver.deposit/2)
      middleware(TranslateErrors)
    end

    field :withdraw, :account do
      arg(:id, non_null(:string))
      arg(:amount, non_null(:integer))
      resolve(&AccountResolver.withdraw/2)
      middleware(TranslateErrors)
    end
  end

  object :account_query do
    field :account, :account do
      arg(:id, non_null(:string))
      resolve(&AccountResolver.get/2)
      middleware(TranslateErrors)
    end
  end

  # object :account_subscrition do
  #   field :account_opened, :account do
  #     arg(:id, non_null(:id))

  #     config(fn %{id: id}, _context ->
  #       {:ok, account_opened: "account_opened:#{id}"}
  #     end)

  #     trigger(:open_account,
  #       account_opened: fn
  #         %{account: nil} -> []
  #         %{account: account} -> "account_opened:#{account.id}"
  #       end
  #     )

  #     resolve(fn %{account: account}, _args, _resolution ->
  #       {:ok, account}
  #     end)
  #   end
  # end

  object :account do
    field(:id, :string)
    field(:current_balance, :integer)
    field(:status, :string)
    field(:user, :user)
    field(:transactions, list_of(:transaction))
  end

  object :user do
    field(:id, :string)
    field(:name, :string)
    field(:goal, :goal)
  end

  object :goal do
    field(:id, :string)
    field(:name, :string)
  end

  object :transaction do
    field(:id, :string)
    field(:type_transaction, :string)
    field(:account, :account)
  end
end
