defmodule Cryptocomparex.ParsetransUtils do
  @price_multi_key_mappings %{
    "OPENHOUR" => "open_hour",
    "TYPE" => "type",
    "LOWDAY" => "low_day",
    "MKTCAP" => "marketcap",
    "VOLUMEDAY" => "volume_day",
    "VOLUMEHOURTO" => "volume_hour_to",
    "TOTALVOLUME24HTO" => "total_volume_24h_to",
    "SUPPLY" => "supply",
    "TOTALVOLUME24H" => "total_volume_24h",
    "FLAGS" => "flags",
    "LASTVOLUME" => "last_volume",
    "VOLUMEHOUR" => "volume_hour",
    "VOLUMEDAYTO" => "volume_day_to",
    "LOWHOUR" => "low_hour",
    "VOLUME24HOURTO" => "volume_24h_to",
    "LOW24HOUR" => "low_24h",
    "PRICE" => "price",
    "TOSYMBOL" => "to_symbol",
    "OPENDAY" => "open_day",
    "CHANGE24HOUR" => "change_24h",
    "HIGHHOUR" => "high_hour",
    "FROMSYMBOL" => "from_symbol",
    "LASTTRADEID" => "last_trade_id",
    "VOLUME24HOUR" => "volume_24h",
    "CHANGEPCTDAY" => "change_pct_day",
    "LASTMARKET" => "last_market",
    "HIGHDAY" => "high_day",
    "HIGH24HOUR" => "high_24h",
    "MARKET" => "market",
    "OPEN24HOUR" => "open_24h",
    "CHANGEPCT24HOUR" => "change_pct_24h",
    "CHANGEDAY" => "change_day",
    "LASTVOLUMETO" => "last_volume_to",
    "LASTUPDATE" => "last_update"
  }

  def transform_multi_price_keys(%{"RAW" => raw, "DISPLAY" => display}) do
    %{
      raw: deep_transform(raw),
      display: deep_transform(display)
    }
  end

  def deep_transform(raw) do
    for {from_symbol, to_symbols} <- raw, into: %{} do
      {from_symbol,
       for {to_symbol, data} <- to_symbols, into: %{} do
         {to_symbol,
          for {k, v} <- data, into: %{} do
            if @price_multi_key_mappings[k], do: {@price_multi_key_mappings[k], v}, else: {k, v}
          end}
       end}
    end
  end
end
