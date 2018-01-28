defmodule Log do
	@moduledoc """
	Log library.
	"""

	require Logger
	def  info( message ), do: Logger.info(  message )
	def error( message ), do: Logger.error( message )
	def  warn( message ), do: Logger.warn(  message )
	def debug( message ), do: Logger.debug( message )
end
