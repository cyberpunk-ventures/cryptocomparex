defmodule Cryptocomparex do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "https://min-api.cryptocompare.com"
  plug Tesla.Middleware.JSON

  @moduledoc """
  Documentation for Cryptocomparex.
  """

  @doc """
  Hello world.

  ## Examples

      iex> {:ok, %{body: body}} = Cryptocomparex.get_exchanges()
      iex> is_map(body["Bitfinex"])
      true

  """
  def get_exchanges() do
    get("/data/all/exchanges")
  end
end
