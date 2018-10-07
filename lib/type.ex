defmodule Type do
	@moduledoc """
	Type library.
	"""

	@doc """
	Type check

	## Examples
		iex> Type.is( nil )
		"nil"
		iex> Type.is( "v1" )
		"String"
		iex> Type.is( "2" )
		"Integer"
		iex> Type.is( 2 )
		"Integer"
		iex> Type.is( "true" )
		"Boolean"
		iex> Type.is( true )
		"Boolean"
		iex> Type.is( "false" )
		"Boolean"
		iex> Type.is( false )
		"Boolean"
		iex> Type.is( "12.34" )
		"Float"
		iex> Type.is( 12.34 )
		"Float"
		iex> Type.is( %{ "cs" => "v1", "ci" => "2", "cb" => "true", "cf" => "12.34" } )
		%{ "cs" => "String", "ci" => "Integer", "cb" => "Boolean", "cf" => "Float" }
		iex> Type.is( %{ "cs" => "v1", "ci" => 2, "cb" => true, "cf" => 12.34 } )
		%{ "cs" => "String", "ci" => "Integer", "cb" => "Boolean", "cf" => "Float" }
	"""
	def is( map ) when is_map( map ) do
		map
		|> Enum.reduce( %{}, fn( { k, v }, acc ) -> Map.put( acc, k, v |> is ) end )
	end
	def is( nil ), do: "nil"
	def is( value ) when is_binary( value ) do
		cond do
			is_boolean_string( value )      -> "Boolean"
			is_float_string_safe( value   ) -> "Float"
			is_integer_string_safe( value ) -> "Integer"
			true                            -> "String"
		end
	end
	def is( value ) when is_boolean( value ), do: "Boolean"
	def is( value ) when is_float( value ),   do: "Float"
	def is( value ) when is_integer( value ), do: "Integer"
	def is_boolean_string( value ) when is_binary( value ) do
		String.downcase( value ) == "true" || String.downcase( value ) == "false"
	end
	def is_float_string_safe( value ) when is_binary( value ) do
		try do
			if String.to_float( value ), do: true, else: false
		catch
			_, _ -> false
		end
	end
	def is_integer_string_safe( value ) when is_binary( value ) do
		try do
			if String.to_integer( value ), do: true, else: false
		catch
			_, _ -> false
		end
	end

	@doc """
	aa

	## Examples
		iex> Type.is_empty( nil )
		true
		iex> Type.is_empty( "" )
		true
		iex> Type.is_empty( "abc" )
		false
		iex> Type.is_empty( 123 )
		false
		iex> Type.is_empty( 12.34 )
		false
	"""
	def is_empty( nil ), do: true
	def is_empty( "" ),  do: true
	def is_empty( _ ),   do: false

	@doc """
	aa

	## Examples
		iex> Type.float( nil )
		"NaN"
		iex> Type.float( "" )
		"NaN"
		iex> Type.float( "12.34567" )
		"12.35"
		iex> Type.float( "12.34444" )
		"12.34"
		iex> Type.float( 12.34567 )
		"12.35"
		iex> Type.float( 12.34444 )
		"12.34"
	"""
	def float( nil ), do: "NaN"
	def float( "" ),  do: "NaN"
	def float( value ) when is_number( value ) do
		case is( value ) do
			"Float"   -> value |> Number.to_string( 2 )
			"Integer" -> value |> Number.to_string
		end
	end
	def float( value ) when is_binary( value ) do
		case is( value ) do
			"Float"   -> value |> String.to_float   |> Number.to_string( 2 )
			"Integer" -> value |> String.to_integer |> Number.to_string
		end
	end

	@doc """
	aa

	## Examples
		iex> Type.to_number( nil )
		nil
		iex> Type.to_number( "123" )
		123
		iex> Type.to_number( "12.34" )
		12.34
		iex> Type.to_number( 123 )
		123
		iex> Type.to_number( 12.34 )
		12.34
		iex> Type.to_number( "" )
		nil
		iex> Type.to_number( "abc" )
		nil
	"""
	def to_number( nil ),  do: nil
	def to_number( value ) when is_number( value ), do: value
	def to_number( value ) when is_binary( value ) do
		case is( value ) do
			"Float"   -> value |> String.to_float
			"Integer" -> value |> String.to_integer
			_         -> nil
		end
	end
end
