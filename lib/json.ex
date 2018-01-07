defmodule Json do
	@moduledoc """
	JSON API calllibrary (with parse support).
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
		|> parse( map_function )
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
		|> parse( map_function )
	end

	@doc """
	Put JSON API (header & map_function are optional)

	## Examples
		iex> Json.put( "https://httpbin.org", "/put?param1=value1", "{ data1:value1 }" )[ "args" ]
		%{"param1" => "value1"}
	"""
	def put( domain, path, body, header \\ [], map_function \\ &nop/1 ) do
		domain <> path
		|> HTTPoison.put!( body, header )
		|> parse( map_function )
	end

	@doc """
	Patch JSON API (header & map_function are optional)

	## Examples
		iex> Json.patch( "https://httpbin.org", "/patch?param1=value1", "{ data1:value1 }" )[ "args" ]
		%{"param1" => "value1"}
	"""
	def patch( domain, path, body, header \\ [], map_function \\ &nop/1 ) do
		domain <> path
		|> HTTPoison.patch!( body, header )
		|> parse( map_function )
	end

	@doc """
	Delete JSON API (header & map_function are optional)

	## Examples
		iex> Json.delete( "https://httpbin.org", "/delete?param1=value1" )[ "args" ]
		%{"param1" => "value1"}
	"""
	def delete( domain, path, header \\ [], map_function \\ &nop/1 ) do
		domain <> path
		|> HTTPoison.delete!( header )
		|> parse( map_function )
	end

	@doc """
	Head JSON API (header & map_function are optional)

	## Examples
		iex> Json.head( "https://httpbin.org", "/", [] ).status_code
		200
	"""
	def head( domain, path, header \\ [] ) do
		domain <> path
		|> HTTPoison.head!( header )
	end

	defp parse( response, map_function ) do
		response
		|> get_body
		|> Poison.decode!
		|> map_function.()
	end
	defp get_body( %{ status_code: 200, body: body } ), do: body
	defp nop( map_list ), do: map_list
end
