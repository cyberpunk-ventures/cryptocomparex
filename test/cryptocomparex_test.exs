defmodule CryptocomparexTest do
  use ExUnit.Case
  doctest Cryptocomparex
  alias Cryptocomparex.HistoOhlcvsOpts
  alias Cryptocomparex.Opts

  test "gets and parses get_histo_day response" do
    opts = %HistoOhlcvsOpts{fsym: "BTC", tsym: "USD"}
    {:ok, %{body: _body = %{data: data}}} = Cryptocomparex.get_histo_daily_ohlcvs(opts)

    assert is_list(data)
    assert is_float(hd(data).high)
  end

  test "gets and parses get_daily_avg response" do
    {:ok, ndt} = NaiveDateTime.new(2018, 1, 1, 0, 0, 0)
    to_ts = ndt |> DateTime.from_naive!("Etc/UTC") |> DateTime.to_unix()

    opts = %HistoOhlcvsOpts{fsym: "BTC", tsym: "USD", to_ts: to_ts}

    {:ok, %{body: body}} = Cryptocomparex.get_histo_daily_avg(opts)

    assert body.usd == 13406.61
  end

  test "gets and parses get_full_data_multi response" do
    opts = %HistoOhlcvsOpts{fsym: "BTC", tsym: "USD"}

    {:ok, %{body: body}} = Cryptocomparex.get_full_data_multi(opts)

    assert is_map(body.display.btc)
    assert is_map(body.raw.btc)

    %{
      change_24h: _,
      change_day: _,
      change_pct_24h: _,
      change_pct_day: _,
      from_symbol: _,
      high_24h: _,
      high_day: _,
      high_hour: _,
      last_market: _,
      last_trade_id: _,
      last_update: _,
      last_volume: _,
      last_volume_to: _,
      low_24h: _,
      low_day: _,
      low_hour: _,
      market: _,
      marketcap: _,
      open_24h: _,
      open_day: _,
      open_hour: _,
      price: _,
      supply: _,
      to_symbol: _,
      total_volume_24h: _,
      total_volume_24h_to: _,
      volume_24h: _,
      volume_24h_to: _,
      volume_day: _,
      volume_day_to: _,
      volume_hour: _,
      volume_hour_to: _
    } = body.raw.btc.usd

    %{
      change_24h: _,
      change_day: _,
      change_pct_24h: _,
      change_pct_day: _,
      from_symbol: _,
      high_24h: _,
      high_day: _,
      high_hour: _,
      last_market: _,
      last_trade_id: _,
      last_update: _,
      last_volume: _,
      last_volume_to: _,
      low_24h: _,
      low_day: _,
      low_hour: _,
      market: _,
      marketcap: _,
      open_24h: _,
      open_day: _,
      open_hour: _,
      price: _,
      supply: _,
      to_symbol: _,
      total_volume_24h: _,
      total_volume_24h_to: _,
      volume_24h: _,
      volume_24h_to: _,
      volume_day: _,
      volume_day_to: _,
      volume_hour: _,
      volume_hour_to: _
    } = body.display.btc.usd
  end

  test "get ohlcv with multiple granularities" do
    opts_day = %Opts{fsym: "BTC", tsym: "USD", granularity: :day}
    opts_hour = %Opts{fsym: "BTC", tsym: "USD", granularity: :hour}
    opts_minute = %Opts{fsym: "BTC", tsym: "USD", granularity: :minute}

    {:ok, %{body: body_day}} = Cryptocomparex.get_ohlcvs(opts_day)
    {:ok, %{body: body_hour}} = Cryptocomparex.get_ohlcvs(opts_hour)
    {:ok, %{body: body_minute}} = Cryptocomparex.get_ohlcvs(opts_minute)

    assert %{high: _, low: _} = hd(body_day.data)
    assert %{high: _, low: _} = hd(body_hour.data)
    assert %{high: _, low: _} = hd(body_minute.data)
  end
end
