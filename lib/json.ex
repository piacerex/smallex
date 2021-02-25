defmodule Json do
	@moduledoc """
	JSON API call library (with parse support).
	"""

	@doc """
	Get JSON API (header & map_function are optional)

	## Examples
		iex> Json.get( "https://api.github.com", "/rate_limit" )[ "rate" ][ "limit" ]
		60
		
		iex> Json.get_raw_response( "https://api.github.com", "/rate_limit" ).status_code
		200
	"""
	def get_raw_response( domain, path, header \\ [] ) do
		domain <> path
		|> HTTPoison.get!( header )
	end
	def get( domain, path, header \\ [] ) do
		get_raw_response( domain, path, header )
		|> parse
	end

	@doc """
	Post JSON API (header & map_function are optional)

	## Examples
		iex> Json.post( "https://httpbin.org", "/post?param1=value1", "{ data1:value1 }", "Content-Type": "application/json" )[ "args" ]
		%{"param1" => "value1"}

		iex> Json.post( "https://httpbin.org", "/post?param1=value1", "{ data1:value1 }", "Content-Type": "application/json" )[ "data" ]
		"{ data1:value1 }"

		iex> Json.post( "https://httpbin.org", "/post?param1=value1", %{ data1: "value1" }, "Content-Type": "application/json" )[ "data" ]
		"{data1:value1}"

		iex> Json.post( "https://httpbin.org", "/post?param1=value1", [ data1: "value1" ], "Content-Type": "application/json" )[ "data" ]
		"{data1:value1}"
		
		iex> Json.post( "https://httpbin.org", "/post?param1=value1", "{ data1:value1 }" )[ "args" ]
		%{"param1" => "value1"}

		iex> Json.post( "https://httpbin.org", "/post?param1=value1", [ data1: "value1" ], "Content-Type": "application/json" )[ "data" ]
		"{data1:value1}"
		
		iex> Json.post_raw_response( "https://httpbin.org", "/post?param1=value1", "{ data1:value1 }", "Content-Type": "application/json" ).status_code
		200
		
		iex> Json.post_raw_response( "https://httpbin.org", "/post?param1=value1", %{ data1: "value1" }, "Content-Type": "application/json" ).status_code
		200

		iex> Json.post_raw_response( "https://httpbin.org", "/post?param1=value1", [ data1: "value1" ], "Content-Type": "application/json" ).status_code
		200
	"""
	def post_raw_response( domain, path, body ), do: post_raw_response( domain, path, body, [] )
	def post_raw_response( domain, path, body, header ) when is_list(body) do
		post_raw_response(domain, path, body |> Enum.into(%{}), header)
	end
	def post_raw_response( domain, path, body, header ) when is_map(body) do
		{:ok, body} = body |> Jason.encode
		post_raw_response( domain, path, body |> String.replace("\"", ""), header )
	end
	def post_raw_response( domain, path, body, header ) do
		domain <> path
		|> HTTPoison.post!( body, header )
	end
	def post( domain, path, body ), do: post( domain, path, body, [] )
	def post( domain, path, body, header ) when is_list(body) do
		post(domain, path, body |> Enum.into(%{}), header)
	end
	def post( domain, path, body, header ) when is_map(body) do
		{:ok, body} = body |> Jason.encode
		post( domain, path, body |> String.replace("\"", ""), header )
	end
	def post( domain, path, body, header ) do
		post_raw_response( domain, path, body, header )
		|> parse
	end
	
	@doc """
	Put JSON API (header & map_function are optional)

	## Examples
		iex> Json.put( "https://httpbin.org", "/put?param1=value1", "{ data1:value1 }", "Content-Type": "application/json" )[ "args" ]
		%{"param1" => "value1"}
		
		iex> Json.put( "https://httpbin.org", "/put?param1=value1", %{ data1: "value1" }, "Content-Type": "application/json" )[ "data" ]
		"{data1:value1}"

		iex> Json.put( "https://httpbin.org", "/put?param1=value1", [ data1: "value1" ], "Content-Type": "application/json" )[ "data" ]
		"{data1:value1}"

		iex> Json.put( "https://httpbin.org", "/put?param1=value1", [ data1: "value1" ], "Content-Type": "application/json" )[ "data" ]
		"{data1:value1}"
				
		iex> Json.put_raw_response( "https://httpbin.org", "/put?param1=value1", "{ data1:value1 }", "Content-Type": "application/json" ).status_code
		200
		
		iex> Json.put_raw_response( "https://httpbin.org", "/put?param1=value1", %{ data1: "value1" }, "Content-Type": "application/json" ).status_code
		200
		
		iex> Json.put_raw_response( "https://httpbin.org", "/put?param1=value1",  [ data1: "value1" ], "Content-Type": "application/json" ).status_code
		200
	"""
	def put_raw_response( domain, path, body ), do: post_raw_response( domain, path, body, [])
	def put_raw_response( domain, path, body, header ) when is_list( body ) do
		put_raw_response( domain, path, body |> Enum.into(%{}), header )
	end
	def put_raw_response( domain, path, body, header) when is_map( body ) do
		{ :ok, body } = body |> Jason.encode
		put_raw_response( domain, path, body |> String.replace("\"", ""), header )
	end
	def put_raw_response( domain, path, body, header ) do
		domain <> path
		|> HTTPoison.put!( body, header )
	end
	def put( domain, path, body ), do: post( domain, path, body, [] )
	def put( domain, path, body, header ) when is_list(body) do
		put( domain, path, body |> Enum.into(%{}), header )
	end
	def put( domain, path, body, header ) when is_map(body) do
		{ :ok, body } = body |> Jason.encode
		put( domain, path, body |> String.replace("\"", ""), header )
	end
	def put( domain, path, body, header ) do
		put_raw_response( domain, path, body, header )
		|> parse
	end

	@doc """
	Patch JSON API (header & map_function are optional)

	## Examples
		iex> Json.patch( "https://httpbin.org", "/patch?param1=value1", "{ data1:value1 }", "Content-Type": "application/json" )[ "args" ]
		%{"param1" => "value1"}
	"""
	def patch( domain, path, body, header \\ [] ) do
		domain <> path
		|> HTTPoison.patch!( body, header )
		|> parse
	end

	@doc """
	Delete JSON API (header & map_function are optional)

	## Examples
		iex> ( Json.delete( "https://httpbin.org", "/delete?param1=value1", "Content-Type": "application/json" ) |> Poison.decode! )[ "args" ]
		%{"param1" => "value1"}
	
		iex> Json.delete_raw_response("https://httpbin.org", "/delete?param1=value1", "Content-Type": "application/json" ).status_code
		200
	"""
	def delete_raw_response( domain, path, header \\ [] ) do
		domain <> path
		|> HTTPoison.delete!( header )
	end
	def delete( domain, path, header \\ [] ) do
		delete_raw_response( domain, path, header )
		|> get_body
	end

	@doc """
	Head JSON API (header & map_function are optional)

	## Examples
		iex> Json.head( "https://httpbin.org", "/", [] )
		""
	"""
	def head( domain, path, header \\ [] ) do
		domain <> path
		|> HTTPoison.head!( header )
		|> get_body
	end

	defp parse( response ) do
		response
		|> get_body
		|> Poison.decode!
	end
	defp get_body( %{ status_code: 200, body: body } ), do: body
	defp get_body( %{ status_code: 201, body: body } ), do: body
	defp get_body( %{ status_code: 204, body: body } ), do: body
end
