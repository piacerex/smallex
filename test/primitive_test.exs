defmodule PrimitiveFunctionTest do
	use PowerAssert

	test "call by value", do: assert Receiver.by_value( "by value" ) == "This is value by value"

	test "call by local function", do: assert TestCall.by_function( &local_function/1 ) == "This is local function call by function"
	def local_function( value ), do: "This is local function #{value}"

	test "call by other module function", do: assert TestCall.by_function( &Receiver.module_function/1 ) == "This is other module function call by function"

	test "call by other module", do: assert TestCall.by_module( Receiver ) == "This is value call by value via module"
end

defmodule TestCall do
	def by_function( function ), do: "call by function" |> function.()
	def by_module( module ), do: "call by value via module" |> module.by_value
end

defmodule Receiver do
	def by_value( value ), do: "This is value #{value}"
	def module_function( value ), do: "This is other module function #{value}"
end
