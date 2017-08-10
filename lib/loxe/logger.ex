require Elixir.Logger

defmodule Loxe.Logger do
  @moduledoc """
  Utility module for logfmt formatted logging
  """

  defmacro __using__(_opts) do
    quote location: :keep do
      require Elixir.Logger
      require Loxe.Logger
    end
  end

  def reset(list \\ []), do: Elixir.Logger.reset_metadata(list)

  @spec metadata :: term
  def metadata, do: Elixir.Logger.metadata
  @spec metadata(list) :: term
  def metadata(list), do: Elixir.Logger.metadata(list)

  @spec context(list, function) :: term
  def context(new_metadata, fun) do
    old_metadata = metadata()
    try do
      metadata(new_metadata)
      fun.()
    after
      reset(old_metadata)
    end
  end

  defmacro log(list, msg \\ nil) do
    quote do: Elixir.Logger.log(Loxe.Formatter.format(unquote(list), unquote(msg)))
  end

  defmacro info(list, msg \\ nil) do
    quote do: Elixir.Logger.info(Loxe.Formatter.format(unquote(list), unquote(msg)))
  end

  defmacro debug(list, msg \\ nil) do
    quote do: Elixir.Logger.debug(Loxe.Formatter.format(unquote(list), unquote(msg)))
  end

  defmacro warn(list, msg \\ nil) do
    quote do: Elixir.Logger.warn(Loxe.Formatter.format(unquote(list), unquote(msg)))
  end

  defmacro error(list, msg \\ nil) do
    quote do: Elixir.Logger.error(Loxe.Formatter.format(unquote(list), unquote(msg)))
  end
end
