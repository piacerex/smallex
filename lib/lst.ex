defmodule Lst do
	@moduledoc """
	List library.
	"""

	@doc """
	To CSV

	## Examples
		iex> Lst.to_csv( [ 1, "ab", 8, true ] )
		"1, ab, 8, true"
		# iex> Lst.to_csv( [ 1, "ab", 8, true ], :quote )
		# "\"1\", \"ab\", \"8\", \"true\""
	"""
	def to_csv( list, option \\ nil ) do
		quote = if option == :quote, do: "\"", else: ""
		list |> Enum.reduce( "", fn( v, acc ) -> "#{ acc }, #{ quote }#{ v }#{ quote }" end ) |> String.slice( 2..-1 )
	end

	@doc """
	Calculate frequency of values ftom list

	## Examples
		iex> Lst.frequency( [ "abc", "abc", "xyz", "abc", "def", "xyz" ] )
		%{ "abc" => 3, "def" => 1, "xyz" => 2 }
		iex> Lst.frequency( [ %{ "a" => "abc" }, %{ "a" => "abc" }, %{ "a" => "xyz" }, %{ "a" => "abc" }, %{ "a" => "def" }, %{ "a" => "xyz" } ] )
		%{ %{ "a" => "abc"} => 3, %{ "a" => "def" } => 1, %{ "a" => "xyz" } => 2 }
	"""
	def frequency( list ), do: list |> Enum.reduce( %{}, fn( k, acc ) -> Map.update( acc, k, 1, &( &1 + 1 ) ) end )

	@doc """
	Zip two lists to map

	## Examples
		iex> Lst.zip( [ "a", "b", "c" ], [ 1, 2, 3 ] )
		%{ "a" => 1, "b" => 2, "c" => 3 }
		iex> Lst.zip( [ "a", "b", "c" ], [ 1, 2, 3 ], :atom )
		%{ a: 1, b: 2, c: 3 }
	"""
	def zip( list1, list2, :atom ),    do: Enum.zip( list1, list2 ) |> Enum.reduce( %{}, fn( { k, v }, acc ) -> Map.put( acc, String.to_atom( k ), v ) end )
	def zip( list1, list2, :no_atom ), do: Enum.zip( list1, list2 ) |> Enum.into( %{} )
	def zip( list1, list2 ),           do: zip( list1, list2, :no_atom )

	@doc """
	Zip columns list and list of rows list

	## Examples
		iex> Lst.columns_rows( [ "c1", "c2", "c3" ], [ [ "v1", 2, true ], [ "v2", 5, false ] ] )
		[ %{ "c1" => "v1", "c2" => 2, "c3" => true }, %{ "c1" => "v2", "c2" => 5, "c3" => false } ]
		iex> Lst.columns_rows( [ "c1", "c2", "c3" ], [ [ "v1", 2, true ], [ "v2", 5, false ] ], :atom )
		[ %{ c1: "v1", c2: 2, c3: true }, %{ c1: "v2", c2: 5, c3: false } ]
	"""
	def columns_rows( columns, rows, :atom ),    do: rows |> Enum.map( & zip( columns, &1, :atom ) )
	def columns_rows( columns, rows, :no_atom ), do: rows |> Enum.map( & zip( columns, &1 ) )
	def columns_rows( columns, rows ),           do: columns_rows( columns, rows, :no_atom )
end
