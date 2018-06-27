defmodule Cryptocomparex do
  use Tesla
  alias Cryptocomparex.HistoOhlcvOpts

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

      iex> alias Cryptocomparex.HistoOhlcvOpts
      iex> opts = %HistoOhlcvOpts{fsym: "BTC", tsym: "USD"}
      iex> {:ok, %{body: body = %{data: data}}} = Cryptocomparex.get_histo_daily_ohlcvs(opts)
      iex> is_list(data) and is_float(hd(data).high)
      true

  """
  def get_histo_daily_ohlcvs(%HistoOhlcvOpts{fsym: _fsym, tsym: _tsym} = params) do
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

    iex> alias Cryptocomparex.HistoOhlcvOpts
    iex> opts = %HistoOhlcvOpts{fsym: "BTC", tsym: "USD"}
    iex> {:ok, %{body: body = %{data: data}}} = Cryptocomparex.get_histo_hourly_ohlcvs(opts)
    iex> is_list(data) and is_float(hd(data).high)
    true

  """
  def get_histo_hourly_ohlcvs(%HistoOhlcvOpts{fsym: _fsym, tsym: _tsym} = params) do
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

    iex> alias Cryptocomparex.HistoOhlcvOpts
    iex> opts = %HistoOhlcvOpts{fsym: "BTC", tsym: "USD"}
    iex> {:ok, %{body: body = %{data: data}}} = Cryptocomparex.get_histo_minute_ohlcvs(opts)
    iex> is_list(data) and is_float(hd(data).high)
    true

  """
  def get_histo_minute_ohlcvs(%HistoOhlcvOpts{fsym: _fsym, tsym: _tsym} = params) do
    query =
      params
      |> KeyTools.camelize_keys(true)
      |> Enum.into(Keyword.new())

    get("/data/histominute", query: query)
  end


  @doc """
  Get day average price. The values are based on hourly vwap data and the average can be calculated in different ways. It uses BTC conversion if data is not available because the coin is not trading in the specified currency. If tryConversion is set to false it will give you the direct data. If no toTS is given it will automatically do the current day. Also for different timezones use the UTCHourDiff param

  The calculation types are:

  HourVWAP - a VWAP of the hourly close price
  MidHighLow - the average between the 24 H high and low.
  VolFVolT - the total volume from / the total volume to (only avilable with tryConversion set to false so only for direct trades but the value should be the most accurate average day price)

  try_conversion	If set to false, it will try to get only direct trading values
  fsym	REQUIRED The cryptocurrency symbol of interest [Max character length: 10]
  tsym	REQUIRED The currency symbol to convert into [Max character length: 10]
  e	The exchange to obtain data from (our aggregated average - CCCAGG - by default) [Max character length: 30]
  avg_type	Type of average to calculate (HourVWAP - a HourVWAP of hourly price, MidHighLow - the average between the 24 H high and low, VolFVolT - the total volume to / the total volume from) [Max character length: 30]
  UTC_hour_diff	By deafult it does UTC, if you want a different time zone just pass the hour difference. For PST you would pass -8 for example.
  to_ts	Last unix timestamp to return data for
  extra_params	The name of your application (we recommend you send it) [Max character length: 50]
  sign	If set to true, the server will sign the requests (be default we don't sign them), this is useful for usage in smart contracts

  """
  def get_histo_daily_avg(%{fsym: _fsym, tsym: _tsym, to_ts: _to_ts} = params) do
    query =
      params
      |> KeyTools.camelize_keys(true)
      |> Enum.into(Keyword.new())

    get("/data/dayAvg", query: query)
  end
end
