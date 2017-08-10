require Elixir.Logger

defmodule Loxe.Formatter do
  @spec format(list_or_msg :: list | String.t, msg :: String.t | nil) :: String.t
  def format(list, nil) when is_list(list), do: format(list)
  def format(msg, nil) when is_binary(msg), do: format(msg)
  def format(list, msg), do: Keyword.merge(list, [msg: msg]) |> format

  @spec format(list_or_msg :: list | String.t) :: String.t
  def format(msg) when is_binary(msg), do: format([msg: msg])
  def format(list) when is_list(list) do
    Elixir.Logger.metadata
    |> Keyword.merge(list)
    |> Logfmt.encode
  end
end
