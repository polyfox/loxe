defmodule Loxe.Logger do
  @moduledoc """
  Utility module for logfmt formatted logging
  """
  require Elixir.Logger

  defmacro __using__(_opts) do
    quote location: :keep do
      require Elixir.Logger
      require Loxe.Logger
    end
  end

  @levels [:emergency, :alert, :critical, :error, :warning, :notice, :info, :debug]

  @type metadata :: Elixir.Logger.metadata()

  @doc """
  Reset the logger metadata, an optional list of metadata can be given to replace it
  """
  @spec reset(metadata()) :: :ok
  def reset(list \\ []), do: Elixir.Logger.reset_metadata(list)

  @doc """
  Returns the current metadata of the logger
  """
  @spec metadata :: metadata()
  def metadata, do: Elixir.Logger.metadata()

  @doc """
  Appends the logger metadat with the given list of
  """
  @spec metadata(metadata()) :: :ok
  def metadata(list) do
    Elixir.Logger.metadata(list)
  end

  @doc """
  Set the metadata given new_metadata and execute given function with the changed metadata,
  once execution is complete it will revert the metadata to its original state.

  Note: subsequent metadata/1 calls will be reverted once the context function finishes execution.
  """
  @spec context(metadata(), function()) :: any()
  def context(new_metadata, fun) do
    old_metadata = metadata()
    try do
      metadata(new_metadata)
      fun.()
    after
      reset(old_metadata)
    end
  end

  for level <- @levels do
    defmacro unquote(level)(a, b \\ nil) do
      lvl = unquote(level)
      quote do
        Elixir.Logger.unquote(lvl)(Loxe.Formatter.format(unquote(a), unquote(b)))
      end
    end
  end

  defmacro warn(a, b \\ nil) do
    quote do
      Elixir.Logger.warn(Loxe.Formatter.format(unquote(a), unquote(b)))
    end
  end
end
