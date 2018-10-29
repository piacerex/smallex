defmodule Fl do
	@moduledoc """
	File library.
	"""

	@doc """
	Write file after pipe

	## Examples
		iex> "sample text" |> Fl.write!( "test/sample.txt" )
		:ok
		iex> File.read!( "test/sample.txt" )
		"sample text"
		iex> File.rm!( "test/sample.txt" )
		:ok
	"""
	def write!( content, path, modes \\ [] ), do: File.write!( path, content, modes )
end
