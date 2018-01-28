defmodule Tpl do
	@moduledoc """
	Tuple library.
	"""

	def ok( { :ok, result } ), do: result
	def error( { :error, result } ), do: result

	def both( { :ok, result } ), do: result
	def both( { :error, result } ), do: result
end
