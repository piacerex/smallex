defmodule Json do
	@doc """
	Call JSON API (header & ap_function are optional)

	## Examples
		iex> Json.call( "https://api.github.com", "/rate_limit" ) |> Map.get( "rate" ) |> Map.get( "limit" )
		60
	"""
	def call( domain, path, header \\ [], map_function \\ &nop/1 ) do
		domain <> path
		|> HTTPoison.get!( header )
		|> body
		|> Poison.decode!
		|> map_function.()
	end
	def body( %{ status_code: 200, body: body } ), do: body
	def nop( map_list ), do: map_list
end
