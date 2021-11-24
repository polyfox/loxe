defmodule Loxe.FormatterTest do
  use ExUnit.Case

  alias Loxe.Formatter

  describe "format/1" do
    test "can handle an empty binary" do
      assert "msg=\"\"" == Formatter.format("")
    end

    test "can handle an binary" do
      assert "msg=\"Hello, World!\"" == Formatter.format("Hello, World!")
    end

    test "can handle a empty list" do
      assert "msg=\"\"" == Formatter.format([])
    end

    test "can handle a iodata list" do
      assert "msg=\"Hello, World!\"" == Formatter.format(["Hello", [", World", "!"]])
    end

    test "can handle a keyword list" do
      assert "a=Apple b=Bacon" == Formatter.format([a: "Apple", b: "Bacon"])
    end
  end
end
