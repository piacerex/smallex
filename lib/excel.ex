defmodule Excel do
	@moduledoc """
	Excel library.
	"""

	@doc """
	Load map

	## Parameters
		- `path` : Excel(.xlsx) file path
		- `sheet_number` : Sheet number (0-origin)

	## Examples
		iex> Excel.load_map( "test/test.xlsx", "sheet1" )
		[
			%{ "age" => "49", "id" => "1", "name" => "John Smith" },
			%{ "age" => "45", "id" => "2", "name" => "Zakk Wylde" },
			%{ "age" => "44", "id" => "3", "name" => "piacere" }
        ]
		iex> Excel.load_map( "test/test.xlsx", 0 )
		[
			%{ "age" => "49", "id" => "1", "name" => "John Smith" },
			%{ "age" => "45", "id" => "2", "name" => "Zakk Wylde" },
			%{ "age" => "44", "id" => "3", "name" => "piacere" }
		]
		iex> Excel.load_map( "test/test.xlsx", 1 )
		[
			%{ "id" => "1", "lots" => "30", "name" => "River" },
			%{ "id" => "2", "lots" => "34", "name" => "Soil" }
		]
	"""
	def load_map( path, sheet_name ) when is_binary( sheet_name ) do
		sheet_number = sheet_names( path ) 
			|> Enum.find_index( &( &1 == sheet_name ) )
		load_map( path, sheet_number )
	end
	def load_map( path, sheet_number ) do
		path
		|> Excelion.parse!( sheet_number, 1 ) 
		|> MapList.first_columns_after_rows 
	end

	@doc """
	Load

	## Parameters
		- `path` : Excel(.xlsx) file path
		- `sheet_number` : Sheet number (0-origin)

	## Examples
		iex> Excel.load( "test/test.xlsx", "sheet1" )
		%{
			"columns" => [ "id", "name", "age" ], 
			"rows" => 
			[
				[ "1", "John Smith", "49" ],
				[ "2", "Zakk Wylde", "45" ],
				[ "3", "piacere", "44" ], 
	        ] 
		}
		iex> Excel.load( "test/test.xlsx", 0 )
		%{
			"columns" => [ "id", "name", "age" ], 
			"rows" => 
			[
				[ "1", "John Smith", "49" ],
				[ "2", "Zakk Wylde", "45" ],
				[ "3", "piacere", "44" ], 
	        ] 
		}
		iex> Excel.load( "test/test.xlsx", 1 )
		%{
			"columns" => [ "id", "name", "lots" ], 
			"rows" => 
			[
				[ "1", "River", "30" ],
				[ "2", "Soil", "34" ],
			]
		}
	"""
	def load( path, sheet_name ) when is_binary( sheet_name ) do
		sheet_number = sheet_names( path ) 
			|> Enum.find_index( &( &1 == sheet_name ) )
		load( path, sheet_number )
	end
	def load( path, sheet_number ) when is_number( sheet_number ) do
		path
		|> Excelion.parse!( sheet_number, 1 ) 
		|> Lst.separate( "columns", "rows" )
	end

	@doc """
	Get sheet names

	## Examples
		iex> Excel.sheet_names( "test/test.xlsx" )
		[ "sheet1", "sheet2" ]
	"""
	def sheet_names( path ) do
		path
		|> Excelion.get_worksheet_names 
		|> Tpl.ok
	end

end
