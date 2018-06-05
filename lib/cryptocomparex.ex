defmodule Cryptocomparex do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "https://min-api.cryptocompare.com"
  plug Cryptocomparex.ResponseMiddleware
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

  @doc """
  Hello world.

  ## Examples

      iex> {:ok, %{body: %{data: data}}} = Cryptocomparex.get_coin_list()
      iex> is_map(data["BTC"])
      true

  """

  def get_coin_list() do
    get("data/all/coinlist")
  end

  @doc """
  Get open, high, low, close, volumefrom and volumeto from the daily historical data.The values are based on 00:00 GMT time.It uses BTC conversion if data is not available because the coin is not trading in the specified currency.

  try_conversion	If set to false, it will try to get only direct trading values
  fsym	REQUIRED The cryptocurrency symbol of interest [Max character length: 10]
  tsym	REQUIRED The currency symbol to convert into [Max character length: 10]
  e	The exchange to obtain data from (our aggregated average - CCCAGG - by default) [Max character length: 30]
  aggregate	Time period to aggregate the data over (for daily it's days, for hourly it's hours and for minute histo it's minutes)
  limit	The number of data points to return
  all_data	Returns all data (only available on histo day)
  to_ts	Last unix timestamp to return data for
  extraParams	The name of your application (we recommend you send it) [Max character length: 50]
  sign if set to true, the server will sign the requests (be default we don't sign them), this is useful for usage in smart contracts

    ## Examples

      iex> {:ok, %{body: body = %{data: data}}} = Cryptocomparex.get_histo_day(%{fsym: "BTC", tsym: "USD"})
      iex> is_list(data) and is_float(hd(data).high)
      true

  """
  def get_histo_day(%{fsym: _fsym, tsym: _tsym} = params) do
    query =
      params
      |> KeyTools.camelize_keys(true)
      |> Enum.into(Keyword.new())

    get("/data/histoday", query: query)
  end

  @doc """
  Get open, high, low, close, volumefrom and volumeto from the hourly historical data. It uses BTC conversion if data is not available because the coin is not trading in the specified currency.

  try_conversion	If set to false, it will try to get only direct trading values
  fsym	REQUIRED The cryptocurrency symbol of interest [Max character length: 10]
  tsym	REQUIRED The currency symbol to convert into [Max character length: 10]
  e	The exchange to obtain data from (our aggregated average - CCCAGG - by default) [Max character length: 30]
  aggregate	Time period to aggregate the data over (for daily it's days, for hourly it's hours and for minute histo it's minutes)
  limit	The number of data points to return
  to_ts	Last unix timestamp to return data for
  extra_params	The name of your application (we recommend you send it) [Max character length: 50]
  sign	If set to true, the server will sign the requests (be default we don't sign them), this is useful for usage in smart contracts

    ## Examples

    iex> {:ok, %{body: body = %{data: data}}} = Cryptocomparex.get_histo_hour(%{fsym: "BTC", tsym: "USD"})
    iex> is_list(data) and is_float(hd(data).high)
    true

  """
  def get_histo_hour(%{fsym: _fsym, tsym: _tsym} = params) do
    query =
      params
      |> KeyTools.camelize_keys(true)
      |> Enum.into(Keyword.new())

    get("/data/histohour", query: query)
  end

  @doc """
  Get open, high, low, close, volumefrom and volumeto from the hourly historical data. It uses BTC conversion if data is not available because the coin is not trading in the specified currency.

  try_conversion	If set to false, it will try to get only direct trading values
  fsym	REQUIRED The cryptocurrency symbol of interest [Max character length: 10]
  tsym	REQUIRED The currency symbol to convert into [Max character length: 10]
  e	The exchange to obtain data from (our aggregated average - CCCAGG - by default) [Max character length: 30]
  aggregate	Time period to aggregate the data over (for daily it's days, for hourly it's hours and for minute histo it's minutes)
  limit	The number of data points to return
  to_ts	Last unix timestamp to return data for
  extra_params	The name of your application (we recommend you send it) [Max character length: 50]
  sign	If set to true, the server will sign the requests (be default we don't sign them), this is useful for usage in smart contracts

    ## Examples

    iex> {:ok, %{body: body = %{data: data}}} = Cryptocomparex.get_histo_minute(%{fsym: "BTC", tsym: "USD"})
    iex> is_list(data) and is_float(hd(data).high)
    true

  """
  def get_histo_minute(%{fsym: _fsym, tsym: _tsym} = params) do
    query =
      params
      |> KeyTools.camelize_keys(true)
      |> Enum.into(Keyword.new())

    get("/data/histominute", query: query)
  end
end
