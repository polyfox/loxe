defmodule Loxe.LoggerTest do
  use Loxe.Logger
  use ExUnit.Case

  @levels [:emergency, :alert, :critical, :error, :warn, :warning, :notice, :info, :debug]

  for level <- @levels do
    describe "#{level}/1" do
      test "can log at level given a message as string" do
        Loxe.Logger.unquote(level)("Hello, World")
      end

      test "can log at level given a message as iodata" do
        Loxe.Logger.unquote(level)(["Hello,", [" World", "!"]])
      end

      test "can log at level given a keyword list" do
        Loxe.Logger.unquote(level)([msg: "Hello, World", a: "Egg"])
      end
    end

    describe "#{level}/2" do
      test "can log at level given a message and keyword list" do
        Loxe.Logger.unquote(level)("Hello, World", [a: "Egg"])
      end

      test "can log at level given a keyword list and message" do
        # this was the 0.2.0 format
        Loxe.Logger.unquote(level)([a: "Egg"], "Hello, World")
      end
    end
  end
end
