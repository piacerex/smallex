defmodule Lst do
	@moduledoc """
	List library.
	"""

	@doc """
	Pad number at zero (string return)

	## Examples
		iex> Lst.to_csv( [ 1, "ab", 8, true ] )
		"1, ab, 8, true"
	"""
	def to_csv( list ), do: list |> Enum.reduce( "", fn( v, acc ) -> "#{ acc }, #{ v }" end ) |> String.slice( 2..-1 )

	@doc """
	Calculate frequency of values ftom list

	## Examples
		iex> Lst.frequency( [ "abc", "abc", "xyz", "abc", "def", "xyz" ] )
		%{ "abc" => 3, "def" => 1, "xyz" => 2 }
		iex> Lst.frequency( [ %{ "a" => "abc" }, %{ "a" => "abc" }, %{ "a" => "xyz" }, %{ "a" => "abc" }, %{ "a" => "def" }, %{ "a" => "xyz" } ] )
		%{ %{ "a" => "abc"} => 3, %{ "a" => "def" } => 1, %{ "a" => "xyz" } => 2 }
	"""
	def frequency( list ), do: list |> Enum.reduce( %{}, fn( k, acc ) -> Map.update( acc, k, 1, &( &1 + 1 ) ) end )
end
