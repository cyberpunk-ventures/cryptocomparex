# Cryptocomparex

Cryptocomparex is an unofficial Elixir/Erlang API client for Cryptocompare API.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `cryptocomparex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:cryptocomparex, "~> 0.1.0"}
  ]
end
```

The docs can be found at [https://hexdocs.pm/cryptocomparex](https://hexdocs.pm/cryptocomparex).

### Status and roadmap

#### Historical API

- [x] get_exchanges()
- [x] get_coin_list()
- [x] get_histo_daily_ohlcvs()
- [x] get_histo_hourly_ohlcvs()
- [x] get_histo_minute_ohlcvs()
- [x] get_histo_daily_avg()
- [ ] get_histo_ohlcvs_for_timestamp()
- [ ] get_histo_daily_volume()
- [ ] get_histo_hourly_volume()

#### Price API

- [ ] get_price_for_symbol()
- [ ] get_price_for_multiple_symbols()
- [ ] get_custom_avg()

#### Streaming API

- [ ] subs_watchlist()
- [ ] subs_by_pair()
- [ ] coins_general_info()


## Docs and examples

### Exchanges

```
iex> {:ok, %{body: body}} = Cryptocomparex.get_exchanges()
iex> is_map(body["Bitfinex"])
true
```


### Coin list
```
iex> {:ok, %{body: %{data: data}}} = Cryptocomparex.get_coin_list()
iex> is_map(data["BTC"])
true

```

### Historical OHLCVs data

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


```
iex> alias Cryptocomparex.HistoOhlcvsOpts
iex> opts = %HistoOhlcvsOpts{fsym: "BTC", tsym: "USD"}
iex> {:ok, %{body: body = %{data: data}}} = Cryptocomparex.get_histo_daily_ohlcvs(opts)
iex> {:ok, %{body: _body = %{data: _data}}} = Cryptocomparex.get_histo_hourly_ohlcvs(opts)
iex> {:ok, %{body: _body = %{data: _data}}} = Cryptocomparex.get_histo_minute_ohlcvs(opts)
iex> is_list(data) and is_float(hd(data).high)
true
```

### Historical aggregated data

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


```

iex> {:ok, ndt} = NaiveDateTime.new(2018, 1, 1, 0, 0, 0)
iex> to_ts = ndt |> DateTime.from_naive!("Etc/UTC") |> DateTime.to_unix()
iex> opts = %{fsym: "BTC", tsym: "USD", to_ts: to_ts}
iex> {:ok, %{body: body}} = Cryptocomparex.get_histo_daily_avg(opts)
iex> is_map(body) and is_float(hd(data).high)

```
