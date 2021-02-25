defmodule LstDocTest do
  use PowerAssert
  doctest Lst

  test "check" do
    assert(Lst.to_csv([1, "ab", 8, true], :quote) == "\"1\",\"ab\",\"8\",\"true\"")
  end
end
