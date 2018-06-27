defmodule Cryptocomparex.HistoOhlcvOpts do
  @enforce_keys [:fsym, :tsym]
  defstruct [:fsym, :tsym, :e, :aggregate, :limit, :all_data, :to_ts, :extra_params, :sign]
end
