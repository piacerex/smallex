defmodule Json do
	def call( domain, path, header, map_function ) do
		domain <> path
		|> HTTPoison.get!( header )
		|> body
		|> Poison.decode!
		|> map_function.()
	end
	def body( %{ status_code: 200, body: body } ), do: body
end
