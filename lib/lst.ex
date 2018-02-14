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
	def to_csv( list ), do: list |> Enum.reduce( "", fn( x, acc ) -> "#{acc}, #{x}" end ) |> String.slice( 2..-1 )
end
