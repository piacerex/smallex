defmodule MapList do
	@moduledoc """
	Map list library.
	"""

	@doc """
	Zip two lists to map( key => value style)

	## Examples
		iex> MapList.zip( [ "a", "b", "c" ], [ 1, 2, 3 ] )
		%{ "a" => 1, "b" => 2, "c" => 3 }
	"""
	def zip( list1, list2 ), do: Enum.zip( list1, list2 ) |> Enum.into( %{} )

	@doc """
	Zip two lists to map( key: value style)

	## Examples
		iex> MapList.zip_atom( [ "a", "b", "c" ], [ 1, 2, 3 ] )
		%{ a: 1, b: 2, c: 3 }
	"""
	def zip_atom( list1, list2 ), do: Enum.zip( list1, list2 ) |> Enum.reduce( %{}, fn { k, v }, acc -> Map.put( acc, String.to_atom( k ), v ) end )

	@doc """
	Outer join keys to map-list on same key-value pair from another

	## Examples
		iex> MapList.merge( [ %{ "a" => "key1", "b" => 12 }, %{ "a" => "key2", "b" => 22 } ], [ %{ "a" => "key1", "c" => 13 }, %{ "a" => "key3", "c" => 23 } ], "a", "no_match" )
		[ %{ "a" => "key1", "b" => 12, "c" => 13 }, %{ "a" => "key2", "b" => 22, "c" => "no_match" } ]
	"""
	def merge( base_map_list, add_map_list, match_key, no_match_value ) do
		empty_add_map = make_empty_map_without_key( add_map_list, match_key, no_match_value )
		adds = add_map_list |> Enum.map( &( &1[ match_key ] ) )
		match_map_list = base_map_list
			|> Enum.filter( &( adds |> Enum.member?( &1[ match_key ] ) ) )
			|> Enum.map( &( Map.merge( &1, find( add_map_list, &1, match_key ) ) ) )
		nomatch_map_list = no_match( base_map_list, add_map_list, match_key )
			|> Enum.map( &( Map.merge( &1, empty_add_map ) ) )
		match_map_list ++ nomatch_map_list
	end

	@doc """
	Inner join keys to map-list on same key-value pair from another

	## Examples
		iex> MapList.replace( [ %{ "a" => "key1", "b" => 12 }, %{ "a" => "key2", "b" => 22 } ], [ %{ "a" => "key1", "c" => 13 }, %{ "a" => "key3", "c" => 23 } ], "a" )
		[ %{ "a" => "key1", "b" => 12, "c" => 13 }, %{ "a" => "key2", "b" => 22 } ]
	"""
	def replace( base_map_list, add_map_list, match_key ) do
		adds = add_map_list |> Enum.map( &( &1[ match_key ] ) )
		match_map_list = base_map_list
			|> Enum.filter( &( adds |> Enum.member?( &1[ match_key ] ) ) )
			|> Enum.map( &( Map.merge( &1, find( add_map_list, &1, match_key ) ) ) )
		nomatch_map_list = no_match( base_map_list, add_map_list, match_key )
		match_map_list ++ nomatch_map_list
	end

	def no_match( base_map_list, match_map_list, match_key ) do
		matchs = match_map_list |> Enum.map( &( &1[ match_key ] ) )
		base_map_list
		|> Enum.filter( &( !( matchs |> Enum.member?( &1[ match_key ] ) ) ) )
	end

	def find( map_list, match_map, match_key ) do
		map_list |> Enum.find( fn( %{ ^match_key => value } ) -> value == match_map[ match_key ] end )
	end

	def make_empty_map_without_key( map_list, match_key, no_match_value ) do
		keys = map_list
			|> List.first
			|> Map.delete( match_key )
			|> Map.keys
		zip( keys, List.duplicate( no_match_value, Enum.count( keys ) ) )
	end
end
