defmodule Number do
	def pad_zero( number, length \\ 14 ), do: pad( number, length, "0" )
	def pad( number, length, padding ) when is_integer( number ) do
		number |> Integer.to_string |> String.pad_leading( length, padding )
	end
end
