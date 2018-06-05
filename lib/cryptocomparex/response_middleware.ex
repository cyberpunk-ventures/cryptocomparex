defmodule Cryptocomparex.ResponseMiddleware do
  @behaviour Tesla.Middleware
  @moduledoc """
  Parses and converts API responses to corresponding Elixir values, idiomatic underscored atom keys, etc.
  """

  def call(env, next, _options) do
    env
    |> Tesla.run(next)
    |> handle_response()
  end

  def handle_response(response) do
    with {:ok, env = %{body: body, url: url}} <- response do
      env = put_in(env.body, parse_body_for(body, url))

      {:ok, env}
    else
      err -> err
    end
  end

  @doc """
  Matches API endpoints to corresponding parsing functions
  """
  def parse_body_for(body, url) do
    cond do
      is_histo_endpoint?(url) ->
        body =
          body
          |> KeyTools.underscore_keys()
          |> KeyTools.atomize_keys()

        data =
          for ohlcv <- body.data do
            Map.update!(ohlcv, :time, &(DateTime.from_unix!(&1) |> DateTime.to_naive()))
          end

        put_in(body.data, data)

      true ->
        body
    end
  end

  def is_histo_endpoint?(url) do
    String.contains?(url, ["/data/histoday", "/data/histohour", "/data/histominute"])
  end
end
