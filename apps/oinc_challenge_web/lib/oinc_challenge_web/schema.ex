defmodule OincChallengeWeb.Schema do
  use Absinthe.Schema

  alias OincChallengeWeb.Schema.Types.AccountType

  import_types(AccountType)

  query do
    import_fields(:account_query)
  end

  mutation do
    import_fields(:account_mutation)
  end

  # subscription do
  #   import_fields(:account_subscrition)
  # end
end
