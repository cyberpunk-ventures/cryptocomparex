defmodule Cryptocomparex do
  use Tesla
  alias Cryptocomparex.HistoOhlcvsOpts
  alias Cryptocomparex.Opts

  plug Tesla.Middleware.BaseUrl, "https://min-api.cryptocompare.com"
  plug Cryptocomparex.ResponseMiddleware
  plug Tesla.Middleware.JSON

  @moduledoc """
  Documentation for Cryptocomparex.
  """

  @doc """
  Get tickers with price, marketcap and other data with multiple from and to symbols.

  Example response:

  ```
  %{
  change_pct_day: 9.707652279157207,
  high_day: 3623.97,
  high_hour: 3623.97,
  last_volume_to: 84.69906,
  change_pct_24h: 8.97387780757882,
  volume_24h: 98145.62993434526,
  price: 3571.39,
  from_symbol: "BTC",
  total_volume_24h_to: 1668910653.0179288,
  volume_hour_to: 42481787.06062327,
  change_24h: 294.0999999999999,
  to_symbol: "USD",
  marketcap: 62242184920,
  total_volume_24h: 471638.58217289834,
  change_day: 316.02,
  high_24h: 3633.18,
  flags: "2",
  supply: 17428000,
  low_24h: 3223.53,
  last_volume: 0.0237,
  type: "5",
  volume_hour: 11833.581951992031,
  open_24h: 3277.29,
  volume_day_to: 335036492.77656716,
  market: "CCCAGG",
  volume_24h_to: 335021658.3226829,
  volume_day: 98148.20525116021,
  low_day: 3239.06,
  last_update: 1545076351,
  last_trade_id: "9650279",
  open_day: 3255.37,
  last_market: "Cexio",
  open_hour: 3578.41,
  low_hour: 3567.74
  }
  ```
  """
  def get_full_data_multi(%Opts{fsym: fsym, tsym: tsym} = params) do
    query =
      params
      |> Map.drop([:fsym, :tsym])
      |> Map.put(:fsyms, fsym |> List.wrap |> Enum.join(","))
      |> Map.put(:tsyms, tsym |> List.wrap |> Enum.join(","))
      |> build_query_from_opts()

    get("/data/pricemultifull", query: query)
  end

  @doc """
  Returns exchanges

  ## Examples

      iex> {:ok, %{body: body}} = Cryptocomparex.get_exchanges()
      iex> is_map(body[:bitfinex])
      true

  """

  @spec get_exchanges() :: {:ok, Tesla.Env.t()} | {:error, any}
  def get_exchanges() do
    get("/data/all/exchanges")
  end

  @doc """
  Returns coin list

  ## Examples

      iex> {:ok, %{body: %{data: data}}} = Cryptocomparex.get_coin_list()
      iex> is_map(data["BTC"])
      true

  """

  @spec get_coin_list() :: {:ok, Tesla.Env.t()} | {:error, any}
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

      iex> alias Cryptocomparex.HistoOhlcvsOpts
      iex> opts = %HistoOhlcvsOpts{fsym: "BTC", tsym: "USD"}
      iex> {:ok, %{body: _body = %{data: data}}} = Cryptocomparex.get_histo_daily_ohlcvs(opts)
      iex> is_list(data) and is_float(hd(data).high)
      true

  """
  @spec get_histo_daily_ohlcvs(%HistoOhlcvsOpts{}) :: {:ok, Tesla.Env.t()} | {:error, any}
  def get_histo_daily_ohlcvs(%HistoOhlcvsOpts{fsym: _fsym, tsym: _tsym} = opts) do
    query = opts |> build_query_from_opts()

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

    iex> alias Cryptocomparex.HistoOhlcvsOpts
    iex> opts = %HistoOhlcvsOpts{fsym: "BTC", tsym: "USD"}
    iex> {:ok, %{body: _body = %{data: data}}} = Cryptocomparex.get_histo_hourly_ohlcvs(opts)
    iex> is_list(data) and is_float(hd(data).high)
    true

  """
  @spec get_histo_hourly_ohlcvs(%HistoOhlcvsOpts{}) :: {:ok, Tesla.Env.t()} | {:error, any}
  def get_histo_hourly_ohlcvs(%HistoOhlcvsOpts{fsym: _fsym, tsym: _tsym} = opts) do
    query = opts |> build_query_from_opts()

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

    iex> alias Cryptocomparex.HistoOhlcvsOpts
    iex> opts = %HistoOhlcvsOpts{fsym: "BTC", tsym: "USD"}
    iex> {:ok, %{body: _body = %{data: data}}} = Cryptocomparex.get_histo_minute_ohlcvs(opts)
    iex> is_list(data) and is_float(hd(data).high)
    true

  """
  @spec get_histo_minute_ohlcvs(%HistoOhlcvsOpts{}) :: {:ok, Tesla.Env.t()} | {:error, any}
  def get_histo_minute_ohlcvs(%HistoOhlcvsOpts{fsym: _fsym, tsym: _tsym} = opts) do
    query = opts |> build_query_from_opts()

    get("/data/histominute", query: query)
  end

  @doc """
  Get historical OHLCV data

  accepts Cryptocomparex.Opts

  try_conversion	If set to false, it will try to get only direct trading values
  fsym	REQUIRED The cryptocurrency symbol of interest [Max character length: 10]
  tsym	REQUIRED The currency symbol to convert into [Max character length: 10]
  granularity REQUIRED The ohlcv period :day, :hour, :minute
  e	The exchange to obtain data from (our aggregated average - CCCAGG - by default) [Max character length: 30]
  aggregate	Time period to aggregate the data over (for daily it's days, for hourly it's hours and for minute histo it's minutes)
  limit	The number of data points to return
  to_ts	Last unix timestamp to return data for
  extra_params	The name of your application (we recommend you send it) [Max character length: 50]
  sign	If set to true, the server will sign the requests (be default we don't sign them), this is useful for usage in smart contracts
  """
  @spec get_ohlcvs(%Opts{}) :: {:ok, Tesla.Env.t()} | {:error, any}
  def get_ohlcvs(%Opts{fsym: _fsym, tsym: _tsym, granularity: gr} = opts) do
    query = opts |> build_query_from_opts()

    case gr do
      :day ->
        get("/data/histoday", query: query)

      :hour ->
        get("/data/histohour", query: query)

      :minute ->
        get("/data/histominute", query: query)
    end
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
  @spec get_histo_daily_avg(map) :: {:ok, Tesla.Env.t()} | {:error, any}
  def get_histo_daily_avg(%{fsym: _fsym, tsym: _tsym, to_ts: _to_ts} = opts) do
    query = opts |> build_query_from_opts()

    get("/data/dayAvg", query: query)
  end

  defp remove_nil_fields(map) do
    for {k, v} <- map, !is_nil(v), into: %{} do
      {k, v}
    end
  end

  def build_query_from_opts(opts) do
    opts
    |> Map.from_struct()
    |> remove_nil_fields()
    |> KeyTools.camelize_keys(true)
    |> Enum.into(Keyword.new())
  end
end
