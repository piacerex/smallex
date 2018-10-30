defmodule Fl do
	@moduledoc """
	File library.
	"""

	@doc """
	Write file from map list after pipe

	## Examples
		iex> [ %{ "key" => "k1", "value" => "v1" }, %{ "key" => "k2", "value" => "v2" }, %{ "key" => "k3", "value" => "v3" } ] |> Fl.write_map_list!( "test/sample.csv", :no_quote )
		[ %{ "key" => "k1", "value" => "v1" }, %{ "key" => "k2", "value" => "v2" }, %{ "key" => "k3", "value" => "v3" } ] 
		iex> File.read!( "test/sample.csv" )
		"key, value
		k1, v1
		k2, v2
		k3, v3
		"
		iex> File.rm!( "test/sample.csv" )
		:ok
	"""
	def write_map_list!( [ head | _tail ] = map_list, path, option \\ :quote, modes \\ [] ) when is_map( head ) do
		File.write!( path, map_list |> MapList.to_csv( option ), modes )
		map_list
	end

	@doc """
	Write file after pipe

	## Examples
		iex> "sample text" |> Fl.write!( "test/sample.txt" )
		"sample text"
		iex> File.read!( "test/sample.txt" )
		"sample text"
		iex> File.rm!( "test/sample.txt" )
		:ok
	"""
	def write!( content, path, modes \\ [] ) when is_binary( content ) do
		File.write!( path, content, modes )
		content
	end
end
