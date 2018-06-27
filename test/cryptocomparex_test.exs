defmodule CryptocomparexTest do
  use ExUnit.Case
  doctest Cryptocomparex
  alias Cryptocomparex.HistoOhlcvOpts

  test "gets and parses get_histo_day response" do
    opts = %HistoOhlcvOpts{fsym: "BTC", tsym: "USD"}
    {:ok, %{body: body = %{data: data}}} =
      Cryptocomparex.get_histo_daily_ohlcvs(opts)

    assert is_list(data)
    assert is_float(hd(data).high)
  end

  test "gets and parses get_daily_avg response" do
    {:ok, ndt} = NaiveDateTime.new(2018, 1, 1, 0, 0, 0)
    to_ts = ndt |> DateTime.from_naive!("Etc/UTC") |> DateTime.to_unix()

    opts = %{fsym: "BTC", tsym: "USD", to_ts: to_ts}

    {:ok, %{body: body}} =
      Cryptocomparex.get_histo_daily_avg(opts)

    assert body.usd == 13406.61
  end
end
