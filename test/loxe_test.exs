defmodule LoxeTest do
  use ExUnit.Case
  doctest Loxe

  test "greets the world" do
    assert Loxe.hello() == :world
  end
end
