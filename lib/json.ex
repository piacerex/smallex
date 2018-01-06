defmodule Json do
	@moduledoc """
	Documentation for Json.
	"""

	@doc """
	Get JSON API (header & map_function are optional)

	## Examples
		iex> Json.get( "https://api.github.com", "/rate_limit" )[ "rate" ][ "limit" ]
		60
	"""
	def get( domain, path, header \\ [], map_function \\ &nop/1 ) do
		domain <> path
		|> HTTPoison.get!( header )
		|> get_body
		|> Poison.decode!
		|> map_function.()
	end

	@doc """
	Post JSON API (header & map_function are optional)

	## Examples
		iex> Json.post( "https://httpbin.org", "/post?param1=value1", "{ data1:value1 }" )[ "args" ]
		%{"param1" => "value1"}

		iex> Json.post( "https://httpbin.org", "/post?param1=value1", "{ data1:value1 }" )[ "data" ]
		"{ data1:value1 }"
	"""
	def post( domain, path, body, header \\ [], map_function \\ &nop/1 ) do
		domain <> path
		|> HTTPoison.post!( body, header )
		|> get_body
		|> Poison.decode!
		|> map_function.()
	end

	defp get_body( %{ status_code: 200, body: body } ), do: body
	defp nop( map_list ), do: map_list
end
