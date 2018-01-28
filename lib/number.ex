defmodule Number do
	@moduledoc """
	Number library.
	"""

	@doc """
	Pad number at zero (string return)

	## Examples
		iex> Number.pad_zero( 123 )
		"00000000000123"
	"""
	def pad_zero( number, length \\ 14 ), do: pad( number, length, "0" )

	@doc """
	Pad number at any (string return)

	## Examples
		iex> Number.pad( 123, 6, "_" )
		"___123"
	"""
	def pad( number, length, padding ) when is_integer( number ) do
		number |> Integer.to_string |> String.pad_leading( length, padding )
	end

	@doc """
	Calculate percent (string return)

	## Examples
		iex> Number.percent( 100, 8 )
		"12.5%"
		iex> Number.percent( 0, 8 )
		"0.0%"
		iex> Number.percent( 100, 0 )
		"(n/a)"
	"""
	def percent( numerator, denominator ) do
		cond do
			denominator == 0 || denominator == nil -> "(n/a)"
			denominator != 0 -> ( numerator / denominator |> Float.to_string ) <> "%"
		end
	end
end
