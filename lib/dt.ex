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
	Get datetime from string/tuple

	## Examples
		iex> Dt.to_datetime( "2018/1" )
		~N[2018-01-01 00:00:00]
		iex> Dt.to_datetime( "2018/ 1" )
		~N[2018-01-01 00:00:00]
		iex> Dt.to_datetime( "2018/01" )
		~N[2018-01-01 00:00:00]
		iex> Dt.to_datetime( "2018/1/2" )
		~N[2018-01-02 00:00:00]
		iex> Dt.to_datetime( "2018/1/2 3:4" )
		~N[2018-01-02 03:04:00]
		iex> Dt.to_datetime( "2018/1/2 3:4:5" )
		~N[2018-01-02 03:04:05]
		iex> Dt.to_datetime( "2018/1/2 03:04" )
		~N[2018-01-02 03:04:00]
		iex> Dt.to_datetime( "2018/1/2 03:04:05" )
		~N[2018-01-02 03:04:05]
		iex> Dt.to_datetime( "2018/ 1/ 2" )
		~N[2018-01-02 00:00:00]
		iex> Dt.to_datetime( "2018/1/ 2" )
		~N[2018-01-02 00:00:00]
		iex> Dt.to_datetime( "2018/01/ 2" )
		~N[2018-01-02 00:00:00]
		iex> Dt.to_datetime( "2018/01/02" )
		~N[2018-01-02 00:00:00]
		iex> Dt.to_datetime( "2018/01/02 23:44" )
		~N[2018-01-02 23:44:00]
		iex> Dt.to_datetime( "2018/01/02 23:44:09" )
		~N[2018-01-02 23:44:09]
		iex> Dt.to_datetime( "2018/01/02 23:44:09.005" )
		~N[2018-01-02 23:44:09.005]
		iex> Dt.to_datetime( "2018-01-02" )
		~N[2018-01-02 00:00:00]
		iex> Dt.to_datetime( "2018-01-02 23:44" )
		~N[2018-01-02 23:44:00]
		iex> Dt.to_datetime( "2018-01-02 23:44:09" )
		~N[2018-01-02 23:44:09]
		iex> Dt.to_datetime( "2018-01-02 23:44:09.005" )
		~N[2018-01-02 23:44:09.005]
		iex> Dt.to_datetime( "Jan-02-2018" )
		~N[2018-01-02 00:00:00]
		iex> Dt.to_datetime( "Jan-02-2018 23:44" )
		~N[2018-01-02 23:44:00]
		iex> Dt.to_datetime( "Jan-02-2018 23:44:09" )
		~N[2018-01-02 23:44:09]
		iex> Dt.to_datetime( "Jan-02-2018 23:44:09.005" )
		~N[2018-01-02 23:44:09.005]
		iex> Dt.to_datetime( "Jan-02-18" )
		~N[2018-01-02 00:00:00]
		iex> Dt.to_datetime( "Jan-02-18 23:44" )
		~N[2018-01-02 23:44:00]
		iex> Dt.to_datetime( "Jan-02-18 23:44:09" )
		~N[2018-01-02 23:44:09]
		iex> Dt.to_datetime( "Jan-02-18 23:44:09.005" )
		~N[2018-01-02 23:44:09.005]
		#iex> Dt.to_datetime( "Jan-02-98" )
		#~N[1998-01-02 00:00:00]
		#iex> Dt.to_datetime( "Jan-02-98 23:44" )
		#~N[1998-01-02 23:44:00]
		#iex> Dt.to_datetime( "Jan-02-98 23:44:09" )
		#~N[1998-01-02 23:44:09]
		#iex> Dt.to_datetime( "Jan-02-98 23:44:09.005" )
		#~N[1998-01-02 23:44:09.005]
		iex> Dt.to_datetime( "January-02-2018" )
		~N[2018-01-02 00:00:00]
		iex> Dt.to_datetime( "January-02-2018 23:44" )
		~N[2018-01-02 23:44:00]
		iex> Dt.to_datetime( "January-02-2018 23:44:09" )
		~N[2018-01-02 23:44:09]
		iex> Dt.to_datetime( "January-02-2018 23:44:09.005" )
		~N[2018-01-02 23:44:09.005]
		iex> Dt.to_datetime( "2018-01-02 23:44:09Z" )
		~N[2018-01-02 23:44:09]
		iex> Dt.to_datetime( "2018-01-02T23:44:09Z" )
		~N[2018-01-02 23:44:09]
		iex> Dt.to_datetime( { 2018, 1, 2 } )
		~N[2018-01-02 00:00:00]
		iex> Dt.to_datetime( { { 2018, 1, 2 }, { 23, 44, 9 } } )
		~N[2018-01-02 23:44:09]
		iex> Dt.to_datetime( ~D[2018-01-02] )
		~N[2018-01-02 00:00:00]
		iex> Dt.to_datetime( ~N[2018-01-02 23:10:07] )
		~N[2018-01-02 23:10:07]
	"""
	def to_datetime( str ) when is_binary( str ) do
		[
			"%Y/%_m", 
			"%Y/%_m/%_d", 
			"%Y/%_m/%_d %_H:%_M", 
			"%Y/%_m/%_d %_H:%_M:%_S", 
			"%Y/%_m/%_d %_H:%_M:%_S.%_L", 
			"%Y-%_m-%_d", 
			"%Y-%_m-%_d %_H:%_M", 
			"%Y-%_m-%_d %_H:%_M:%_S", 
			"%Y-%_m-%_d %_H:%_M:%_S.%_L", 
			"%b-%_d-%Y", 
			"%b-%_d-%Y %_H:%_M", 
			"%b-%_d-%Y %_H:%_M:%_S", 
			"%b-%_d-%Y %_H:%_M:%_S.%_L", 
			"%b-%_d-%y", 
			"%b-%_d-%y %_H:%_M", 
			"%b-%_d-%y %_H:%_M:%_S", 
			"%b-%_d-%y %_H:%_M:%_S.%_L", 
			"%B-%_d-%Y", 
			"%B-%_d-%Y %_H:%_M", 
			"%B-%_d-%Y %_H:%_M:%_S", 
			"%B-%_d-%Y %_H:%_M:%_S.%_L", 
			"%Y-%_m-%_d %_H:%_M:%_SZ", 
			"%Y-%_m-%_d %_H:%_M:%_S.%_LZ", 
			"%Y-%_m-%_dT%_H:%_M:%_SZ", 
			"%Y-%_m-%_dT%_H:%_M:%_S.%_LZ", 
		]
		|> Enum.map( &( str |> Timex.parse( &1, :strftime ) ) )
		|> Enum.filter( &elem( &1, 0 ) == :ok )
		|> List.first
		|> Tpl.ok
	end
	def to_datetime( value ) do
		value
		|> Timex.to_datetime
		|> DateTime.to_string
		|> to_datetime
	end
end
