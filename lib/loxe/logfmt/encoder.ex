defmodule Loxe.Logfmt.Encoder do
  @moduledoc """
  Loxe's version of Logfmt's Encoder module.

  This is modified to be more optimized specifically for Loxe's case, as well as safely handling
  protocol errors from Logfmt.ValueEncoder which can be a show stopper from accidental values.
  """

  @doc """
  Encodes a given list as a logfmt pair list.

  There are no options, this will always return an iolist.
  """
  @spec encode(Dict.t()) :: iolist()
  def encode(list) do
    # the map + intersperse was great for reading, but when you have log lines blarring
    # along, it's better to just do it all in a single pass to avoid wasting cycles
    encode_and_intersperse(list, " ", [])
  end

  defp encode_and_intersperse([], _spacer, acc) do
    Enum.reverse(acc)
  end

  defp encode_and_intersperse([a], spacer, acc) do
    encode_and_intersperse([], spacer, [encode_pair(a) | acc])
  end

  defp encode_and_intersperse([a, b], spacer, acc) do
    encode_and_intersperse([], spacer, [encode_pair(b), spacer, encode_pair(a) | acc])
  end

  defp encode_and_intersperse([a | rest], spacer, acc) do
    encode_and_intersperse(rest, spacer, [spacer, encode_pair(a) | acc])
  end

  @spec encode_value(value :: term) :: String.t()
  defp encode_value(value)

  defp encode_value(""),
    do: ~s("")

  case Application.compile_env(:loxe, :on_protocol_undefined, :raise) do
    :raise ->
      defp encode_value(value) do
        str = Logfmt.ValueEncoder.encode(value)

        case deduce_and_escape_string(str, :unquoted, []) do
          {:unquoted, str} ->
            str

          {:quoted, str} ->
            ["\"", str, "\""]
        end
      end

    :placeholder ->
      defp encode_value(value) do
        str =
          case Logfmt.ValueEncoder.impl_for(value) do
            nil ->
              "<protocol-undefined>"

            mod ->
              mod.encode(value)
          end

        case deduce_and_escape_string(str, :unquoted, []) do
          {:unquoted, str} ->
            str

          {:quoted, str} ->
            ["\"", str, "\""]
        end
      end

    :inspect ->
      defp encode_value(value) do
        str =
          case Logfmt.ValueEncoder.impl_for(value) do
            nil ->
              inspect(value)

            mod ->
              mod.encode(value)
          end

        case deduce_and_escape_string(str, :unquoted, []) do
          {:unquoted, str} ->
            str

          {:quoted, str} ->
            ["\"", str, "\""]
        end
      end
  end

  defp encode_pair({key, value}) do
    # if an options keyword list was passed in, the " " could be replaced
    # with a user configurable option, but for now we'll keep the space.
    [encode_value(key), "=", encode_value(value)]
  end

  defp deduce_and_escape_string(<<>>, quote_type, acc) do
    {quote_type, Enum.reverse(acc)}
  end

  defp deduce_and_escape_string(<<0x0, rest::binary>>, _quote_type, acc),
    do: deduce_and_escape_string(rest, :quoted, ["\\u0000" | acc])

  defp deduce_and_escape_string(<<0x1, rest::binary>>, _quote_type, acc),
    do: deduce_and_escape_string(rest, :quoted, ["\\u0001" | acc])

  defp deduce_and_escape_string(<<0x2, rest::binary>>, _quote_type, acc),
    do: deduce_and_escape_string(rest, :quoted, ["\\u0002" | acc])

  defp deduce_and_escape_string(<<0x3, rest::binary>>, _quote_type, acc),
    do: deduce_and_escape_string(rest, :quoted, ["\\u0003" | acc])

  defp deduce_and_escape_string(<<0x4, rest::binary>>, _quote_type, acc),
    do: deduce_and_escape_string(rest, :quoted, ["\\u0004" | acc])

  defp deduce_and_escape_string(<<0x5, rest::binary>>, _quote_type, acc),
    do: deduce_and_escape_string(rest, :quoted, ["\\u0005" | acc])

  defp deduce_and_escape_string(<<0x6, rest::binary>>, _quote_type, acc),
    do: deduce_and_escape_string(rest, :quoted, ["\\u0006" | acc])

  defp deduce_and_escape_string(<<0x7, rest::binary>>, _quote_type, acc),
    do: deduce_and_escape_string(rest, :quoted, ["\\u0007" | acc])

  defp deduce_and_escape_string(<<0x8, rest::binary>>, _quote_type, acc),
    do: deduce_and_escape_string(rest, :quoted, ["\\u0008" | acc])

  defp deduce_and_escape_string(<<"\t", rest::binary>>, _quote_type, acc),
    do: deduce_and_escape_string(rest, :quoted, ["\\t" | acc])

  defp deduce_and_escape_string(<<"\n", rest::binary>>, _quote_type, acc),
    do: deduce_and_escape_string(rest, :quoted, ["\\n" | acc])

  defp deduce_and_escape_string(<<0xB, rest::binary>>, _quote_type, acc),
    do: deduce_and_escape_string(rest, :quoted, ["\\u000b" | acc])

  defp deduce_and_escape_string(<<0xC, rest::binary>>, _quote_type, acc),
    do: deduce_and_escape_string(rest, :quoted, ["\\u000c" | acc])

  defp deduce_and_escape_string(<<"\r", rest::binary>>, _quote_type, acc),
    do: deduce_and_escape_string(rest, :quoted, ["\\r" | acc])

  defp deduce_and_escape_string(<<0x0E, rest::binary>>, _quote_type, acc),
    do: deduce_and_escape_string(rest, :quoted, ["\\u000e" | acc])

  defp deduce_and_escape_string(<<0x0F, rest::binary>>, _quote_type, acc),
    do: deduce_and_escape_string(rest, :quoted, ["\\u000f" | acc])

  defp deduce_and_escape_string(<<0x10, rest::binary>>, _quote_type, acc),
    do: deduce_and_escape_string(rest, :quoted, ["\\u0010" | acc])

  defp deduce_and_escape_string(<<0x11, rest::binary>>, _quote_type, acc),
    do: deduce_and_escape_string(rest, :quoted, ["\\u0011" | acc])

  defp deduce_and_escape_string(<<0x12, rest::binary>>, _quote_type, acc),
    do: deduce_and_escape_string(rest, :quoted, ["\\u0012" | acc])

  defp deduce_and_escape_string(<<0x13, rest::binary>>, _quote_type, acc),
    do: deduce_and_escape_string(rest, :quoted, ["\\u0013" | acc])

  defp deduce_and_escape_string(<<0x14, rest::binary>>, _quote_type, acc),
    do: deduce_and_escape_string(rest, :quoted, ["\\u0014" | acc])

  defp deduce_and_escape_string(<<0x15, rest::binary>>, _quote_type, acc),
    do: deduce_and_escape_string(rest, :quoted, ["\\u0015" | acc])

  defp deduce_and_escape_string(<<0x16, rest::binary>>, _quote_type, acc),
    do: deduce_and_escape_string(rest, :quoted, ["\\u0016" | acc])

  defp deduce_and_escape_string(<<0x17, rest::binary>>, _quote_type, acc),
    do: deduce_and_escape_string(rest, :quoted, ["\\u0017" | acc])

  defp deduce_and_escape_string(<<0x18, rest::binary>>, _quote_type, acc),
    do: deduce_and_escape_string(rest, :quoted, ["\\u0018" | acc])

  defp deduce_and_escape_string(<<0x19, rest::binary>>, _quote_type, acc),
    do: deduce_and_escape_string(rest, :quoted, ["\\u0019" | acc])

  defp deduce_and_escape_string(<<0x1A, rest::binary>>, _quote_type, acc),
    do: deduce_and_escape_string(rest, :quoted, ["\\u001a" | acc])

  defp deduce_and_escape_string(<<0x1B, rest::binary>>, _quote_type, acc),
    do: deduce_and_escape_string(rest, :quoted, ["\\u001b" | acc])

  defp deduce_and_escape_string(<<0x1C, rest::binary>>, _quote_type, acc),
    do: deduce_and_escape_string(rest, :quoted, ["\\u001c" | acc])

  defp deduce_and_escape_string(<<0x1D, rest::binary>>, _quote_type, acc),
    do: deduce_and_escape_string(rest, :quoted, ["\\u001d" | acc])

  defp deduce_and_escape_string(<<0x1E, rest::binary>>, _quote_type, acc),
    do: deduce_and_escape_string(rest, :quoted, ["\\u001e" | acc])

  defp deduce_and_escape_string(<<0x1F, rest::binary>>, _quote_type, acc),
    do: deduce_and_escape_string(rest, :quoted, ["\\u001f" | acc])

  defp deduce_and_escape_string(<<"\s", rest::binary>>, _quote_type, acc),
    do: deduce_and_escape_string(rest, :quoted, ["\s" | acc])

  defp deduce_and_escape_string(<<"\"",rest::binary>>, _quote_type, acc),
    do: deduce_and_escape_string(rest, :quoted, ["\\\"" | acc])

  defp deduce_and_escape_string(<<"\\",rest::binary>>, _quote_type, acc),
    do: deduce_and_escape_string(rest, :quoted, ["\\\\" | acc])

  defp deduce_and_escape_string(<<"=",rest::binary>>, _quote_type, acc),
    do: deduce_and_escape_string(rest, :quoted, ["=" | acc])

  defp deduce_and_escape_string(<<c::utf8, rest::binary>>, quote_type, acc),
    do: deduce_and_escape_string(rest, quote_type, [<<c::utf8>> | acc])
end
