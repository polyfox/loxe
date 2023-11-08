defmodule Loxe.FormatterTest do
  use ExUnit.Case

  alias Loxe.Formatter

  describe "format/1" do
    test "can handle an empty binary" do
      assert "msg=\"\"" == IO.iodata_to_binary(Formatter.format(""))
    end

    test "can handle an binary" do
      assert "msg=\"Hello, World!\"" == IO.iodata_to_binary(Formatter.format("Hello, World!"))
    end

    test "can handle a empty list" do
      assert "msg=\"\"" == IO.iodata_to_binary(Formatter.format([]))
    end

    test "can handle a iodata list" do
      assert "msg=\"Hello, World!\"" == IO.iodata_to_binary(Formatter.format(["Hello", [", World", "!"]]))
    end

    test "can handle a keyword list" do
      assert "a=Apple b=Bacon" == IO.iodata_to_binary(Formatter.format([a: "Apple", b: "Bacon"]))
    end

    test "can handle a unencodable value" do
      assert "a=Apple b=<protocol-undefined>" == IO.iodata_to_binary(Formatter.format([a: "Apple", b: ~c"Bacon"]))
    end
  end

  describe "filter_metadata/1" do
    test "will filter keys as specified" do
      assert [
        something: "Should exist"
      ] == Formatter.filter_metadata(something: "Should exist", hide_me: "Shouldn't exist")
    end
  end
end
