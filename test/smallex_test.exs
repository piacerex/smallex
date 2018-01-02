defmodule SmallexTest do
  use ExUnit.Case
  doctest Smallex

  test "greets the world" do
    assert Smallex.hello() == :world
  end
end
