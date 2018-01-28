defmodule Dt do
	@moduledoc """
	DateTime utiity.
	"""

	def now_timestamp( date_sep \\ "", separate \\ "", time_sep \\ "", second_sep \\ "" ) do
		Timex.now |> to_timestamp_string( date_sep, separate, time_sep, second_sep )
	end
	def to_timestamp_string( dt, date_sep \\ "", between_sep \\ "", time_sep \\ "", second_sep \\ "" ) do
		ss = dt |> format( "{ss}" ) |> String.replace( ".", second_sep )
		dt |> format( "{YYYY}#{ date_sep }{0M}#{ date_sep }{0D}#{ between_sep }{h24}#{ time_sep }{m}#{ time_sep }{s}#{ ss }" )
	end
	def format( dt, format_str ) do
		{ :ok, result } = Timex.format( dt, format_str )
		result
	end

	def now_ym(), do: Timex.now |> to_ym_string
	def to_ym_string( dt ), do: dt |> format( "{YYYY}/{0M}" )

	def now_ymd(), do: Timex.now |> to_ymd_string
	def to_ymd_string( dt ), do: dt |> format( "{YYYY}/{0M}/{0D}" )

	@doc """
	Get datetime from tuple

	## Examples
		iex> Dt.to_datetime( { { 2018, 1, 22 }, { 23, 44, 9 } }" )
		~N[2018-01-22 23:44:09]

		iex> Dt.to_datetime( "{ 2018, 1, 22 }" )
		~N[2018-01-22 00:00:00]
	"""
	def to_datetime( tuple ) when is_tuple( tuple ) do
		tuple
		|> Timex.to_datetime
		|> DateTime.to_string
		|> String.slice( 0..-2 )
	end

	@doc """
	Get datetime from string (NOTE: Define this after to_datetime( tuple ))

	## Examples
		iex> Dt.to_datetime( "2018/01/22 23:44:09" )
		~N[2018-01-22 23:44:09]

		iex> Dt.to_datetime( "2018/01/22" )
		~N[2018-01-22 00:00:00]

		iex> Dt.to_datetime( "2018-01-22T23:44:09Z" )
		~N[2018-01-22 23:44:09]
	"""
	def to_datetime( str ) when is_binary( str ) do
		[
			"%Y/%m/%d", 
			"%Y/%m/%d %H:%M", 
			"%Y/%m/%d %H:%M:%S", 
			"%Y/%m/%d %H:%M:%S.%L", 
			"%Y-%m-%dT%H:%M:%SZ", 
		]
		|> Enum.map( &( str |> Timex.parse( &1, :strftime ) ) )
		|> Enum.filter( &elem( &1, 0 ) == :ok )
		|> List.first
		|> Tpl.ok
	end
end
