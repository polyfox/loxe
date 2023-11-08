require Elixir.Logger

defmodule Loxe.Formatter do
  @type keywords_or_message :: Keyword.t() | iodata()

  @spec format(keywords_or_message(), keywords_or_message()) :: iodata()
  def format(list, nil) when is_list(list) do
    format(list)
  end

  def format(msg, nil) when is_binary(msg) do
    format(msg)
  end

  def format(a, b) do
    result = []

    {result, msg} = append_data(result, [], a)
    {result, msg} = append_data(result, msg, b)

    result
    |> Keyword.merge([msg: IO.iodata_to_binary(msg)])
    |> format()
  end

  @spec format(keywords_or_message()) :: iodata()
  def format(msg) when is_list(msg) do
    case msg do
      [{_key, _value} | _] ->
        do_format(msg)

      msg ->
        do_format(msg: IO.iodata_to_binary(msg))
    end
  end

  def format(msg) when is_binary(msg) do
    do_format(msg: msg)
  end

  defp do_format(list) when is_list(list) do
    Elixir.Logger.metadata()
    |> filter_metadata()
    |> Keyword.merge(list)
    |> Loxe.Logfmt.Encoder.encode()
  end

  def filter_metadata(list) when is_list(list) do
    Enum.filter(list, &filter_metadata_pair/1)
  end

  case Application.compile_env(:loxe, :metadata) do
    nil ->
      defp filter_metadata_pair({_, _}) do
        true
      end

    list when is_list(list) ->
      except = Keyword.fetch(list, :except)
      only = Keyword.fetch(list, :only)

      case except do
        :error ->
          :ok

        {:ok, list} when is_list(list) ->
          for key <- list do
            defp filter_metadata_pair({unquote(key), _}) do
              false
            end
          end
      end

      case only do
        :error ->
          defp filter_metadata_pair({_, _}) do
            true
          end

        {:ok, list} when is_list(list) ->
          for key <- list do
            defp filter_metadata_pair({unquote(key), _}) do
              true
            end
          end

          # if there is an only filter, all other metadata keys should be left unhandled
          defp filter_metadata_pair({_, _}) do
            false
          end
      end
  end

  defp is_kw_list?([{_key, _value} | _]) do
    true
  end

  defp is_kw_list?(_) do
    false
  end

  defp append_data(result, msg, item) do
    cond do
      is_kw_list?(item) ->
        {Keyword.merge(result, item), msg}

      is_list(item) ->
        {result, append_message(msg, item)}

      true ->
        {result, append_message(msg, item)}
    end
  end

  defp append_message([], item) when is_binary(item) do
    [item]
  end

  defp append_message(msg, item) when is_binary(item) do
    [msg, " ", item]
  end

  defp append_message(msg, item) when is_list(item) do
    append_message(msg, IO.iodata_to_binary(item))
  end

  defp append_message(msg, item) do
    append_message(msg, Logfmt.ValueEncoder.encode(item))
  end
end
