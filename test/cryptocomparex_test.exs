defmodule CryptocomparexTest do
  use ExUnit.Case
  doctest Cryptocomparex

  test "gets and parses get_histo_day response" do
    {:ok, %{body: body = %{data: data}}} =
      Cryptocomparex.get_histo_day(%{fsym: "BTC", tsym: "USD"})

    assert is_list(data)
    assert is_float(hd(data).high)
  end

  test "gets and parses get_daily_avg response" do
    {:ok, ndt} = NaiveDateTime.new(2018, 1, 1, 0, 0, 0)
    to_ts = ndt |> DateTime.from_naive!("Etc/UTC") |> DateTime.to_unix()

    {:ok, %{body: body}} =
      Cryptocomparex.get_daily_avg(%{fsym: "BTC", tsym: "USD", to_ts: to_ts})

    assert body["USD"] == 13406.61
  end
end
