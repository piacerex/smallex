defmodule MapListDocTest do
	use PowerAssert
	doctest MapList

	test "check" do
		assert( MapList.to_csv( [ %{ "c1" => "v1", "c2" => 2, "c3" => true }, %{ "c1" => "v2", "c2" => 5, "c3" => false } ] ) == "c1,c2,c3\n\"v1\",\"2\",\"true\"\n\"v2\",\"5\",\"false\"\n" )
	end
end
