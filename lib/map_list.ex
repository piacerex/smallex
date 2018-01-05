defmodule MapList do

	def zip( map_list1, map_list2 ), do: Enum.into( List.zip( [ map_list1, map_list2 ] ), %{} )

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

	def replacep( base_map_list, add_map_list, match_key ) do
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

	def frequency( map_list ), do: map_list |> Enum.reduce( %{}, fn( key, new_map ) -> Map.update( new_map, key, 1, &( &1 + 1 ) ) end )

	def dig( map_list, key ) do
		%{ ^key => value } = map_list
		value
	end
end
