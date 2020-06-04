defmodule Checkout.Charge do
  @moduledoc """
  Checkout API reference: https://archive.docs.checkout.com/docs/capture_a_payment
  """

  @endpoint "payments"

  @doc """
  Create a Charge with Card ID.

  ## Example
  ```
  Checkout.Charge.create(%{
    source: %{
      type: "id",
      id: "src_en2w67spfevehol7rh6m5zokeq",
      cvv: "100",
    },
    email: "test@example.org",
    amount: 6500,
    currency: "USD",
    reference: "ORD-5023-4E89"
  })
  ```
  Create a Payment with Card Token.

  ## Example
  ```
    Checkout.Charge.create(%{
      source: %{
        type: "token",
        token: "card_tok_9EDE49...A52CC25"
      },
      amount: 2000,
      currency: "USD",
      reference: "TRK12345"
    })
  ```
  Create a Charge with Full Card.

  ## Example
  ```
    Checkout.Charge.create(%{
      source: %{
        type: "card",
        number: "4242424242424242",
        expiry_month: 8,
        expiry_year: 2022,
        cvv: "100"
      },
      amount: 2000,
      currency: "USD",
      reference: "TRK12345"
    })
  ```
  Create a Charge with Default card.

  ## Example
  ```
    Checkout.Charge.create(%{
  	  source: %{
        type: "customer",
        id: "cus_lmxvhq5nzgmudlm2ovnxpzsig4",
      },
      amount: 2000,
      currency: "USD"
    })
  ```
  """
  def create(params) do
    Checkout.make_request(:post, @endpoint, params)
  end
end
