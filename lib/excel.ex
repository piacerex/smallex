defmodule Excel do
	@moduledoc """
	Excel library.
	"""

	@doc """
	Load

	## Parameters
		- `path` : Excel(.xlsx) file path
		- `sheet_number` : Sheet number (0-origin)

	## Examples
		iex> Excel.load( "test/test.xlsx" )
		[
              %{ "age" => "49", "id" => "1", "name" => "John Smith" },
              %{ "age" => "45", "id" => "2", "name" => "Zakk Wylde" },
              %{ "age" => "44", "id" => "3", "name" => "piacere" }
        ]
		iex> Excel.load( "test/test.xlsx", 0 )
		[
			%{ "age" => "49", "id" => "1", "name" => "John Smith" },
			%{ "age" => "45", "id" => "2", "name" => "Zakk Wylde" },
			%{ "age" => "44", "id" => "3", "name" => "piacere" }
		]
		iex> Excel.load( "test/test.xlsx", 1 )
		[
			%{ "id" => "1", "lots" => "30", "name" => "River" },
			%{ "id" => "2", "lots" => "34", "name" => "Soil" }
		]
	"""
	def load( path, sheet_number \\ 0 ) do
		path
		|> Excelion.parse!( sheet_number, 1 ) 
		|> MapList.first_columns_after_rows 
	end
end
