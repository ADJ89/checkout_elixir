defmodule Checkout do
  use HTTPoison.Base

  @live_url "https://api2.checkout.com/v2/"
  @sandbox_url "https://sandbox.checkout.com/api2/v2/"

  def process_url(endpoint) do
    url =
      api_url()
      |> URI.parse
      |> remove_path_if_needed(endpoint)
      |> URI.to_string

    url <> endpoint
  end

  def process_request_headers(secret_key \\ true) do
    [
      {"Content-Type", "application/json;charset=UTF-8"},
      {"Authorization",
        if secret_key do
          Application.get_env(:checkout_elixir, :secret_key, System.get_env("CHECKOUT_SECRET_KEY"))
        else
          Application.get_env(:checkout_elixir, :public_key, System.get_env("CHECKOUT_PUBLIC_KEY"))
        end
      }
    ]
  end

  def process_request_body(body) do
    Poison.encode!(body)
  end

  def process_response_body(body) do
    body
    |> Poison.decode!([keys: :atoms])
  end

  def make_request(method, endpoint, body \\ "", headers \\ [], options \\ []) do
    {:ok, response} = request(method, endpoint, body, headers, options)
    case response.status_code do
      200 -> {:ok, response.body}
      400 -> {:error, response.body}
      401 -> {:error, :unauthorized}
      404 -> {:error, :not_found}
    end
  end

  defp api_url do
    if Application.get_env(:checkout_elixir, :sandbox, false) do
      @sandbox_url
    else
      @live_url
    end
  end

  defp remove_path_if_needed(uri, endpoint) do
    if String.match?(endpoint, ~r/applepay/) do
      Map.replace(uri, :path, "/")
    else
      uri
    end
  end
end