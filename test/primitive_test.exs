defmodule PrimitiveValueTest do
  use PowerAssert

  test "number equal number", do: assert(1 == 1)
  test "is_number", do: assert(is_number(1) == true)

  test "is_list", do: assert(is_list([1, 2, 3]) == true)

  test "string is_binary", do: assert(is_binary("test") == true)
  test "string not is_list", do: assert(is_list("test") == false)

  test "true is_boolean", do: assert(is_boolean(true) == true)
  test ":true is_boolean", do: assert(is_boolean(true) == true)
  test "false is_boolean", do: assert(is_boolean(false) == true)
  test ":false is_boolean", do: assert(is_boolean(false) == true)
  test "1 not is_boolean", do: assert(is_boolean(1) == false)
  test "0 not is_boolean", do: assert(is_boolean(0) == false)
end

defmodule PrimitiveSyntaxSugarTest do
  use PowerAssert

  test "keyword list same tuple list", do: assert([c1: 6, c2: 7] == [{:c1, 6}, {:c2, 7}] == true)

  # Following tests succeeds but warning is issued
  # 	test "keyword list(key string atom) same tuple list", do: assert ( [ "c1": 6, "c2": 7 ] == [ { :c1, 6 }, { :c2, 7 } ] ) == true
  # 	test "keyword list same tuple list(key string atom)", do: assert ( [ c1: 6, c2: 7 ] == [ { :"c1", 6 }, { :"c2", 7 } ] ) == true

  test "keyword list not same tuple list(key string)",
    do: assert([c1: 6, c2: 7] == [{"c1", 6}, {"c2", 7}] == false)
end

defmodule PrimitiveDateTimeTest do
  use PowerAssert

  test "Date valid", do: assert(Date.new(2018, 6, 4) == {:ok, ~D[2018-06-04]})
  test "Date invalid", do: assert(Date.new(2018, 2, 30) == {:error, :invalid_date})

  test "Time valid", do: assert(Time.new(23, 10, 7, 5000) == {:ok, ~T[23:10:07.005000]})
  test "Time invalid", do: assert(Time.new(23, 61, 7, 5000) == {:error, :invalid_time})

  # 	test "DateTime valid",   do: assert DateTime.from_iso8601( "2018-06-04T16:01:09Z" ) == { :ok, #DateTime<2018-06-04 16:01:09Z>, 0 }
  test "DateTime invalid",
    do: assert(DateTime.from_iso8601("2018-02-30T16:01:09Z") == {:error, :invalid_date})

  test "NaiveDateTime valid",
    do:
      assert(
        NaiveDateTime.new(2010, 1, 13, 23, 10, 7, 5000) == {:ok, ~N[2010-01-13 23:10:07.005000]}
      )

  test "NaiveDateTime invalid",
    do: assert(NaiveDateTime.new(2010, 2, 30, 23, 10, 7, 5000) == {:error, :invalid_date})

  test "NaiveDateTime to_erl",
    do:
      assert(NaiveDateTime.to_erl(~N[2010-01-13 23:10:07.005000]) == {{2010, 1, 13}, {23, 10, 7}})
end

defmodule PrimitiveTimexTest do
  use PowerAssert

  test "Timex is_valid DateTime",
    do: assert(Timex.is_valid?(~N[2010-01-13 23:10:07.005000]) == true)

  test "Timex is_valid Date", do: assert(Timex.is_valid?(~D[2018-06-04]) == true)

  test "Timex is_valid Tuple DateTime",
    do: assert(Timex.is_valid?({{2010, 1, 13}, {23, 10, 7}}) == true)

  test "Timex is_valid String Date invalid", do: assert(Timex.is_valid?("2018-06-04") == false)

  test "Timex is_valid String Date Slash invalid",
    do: assert(Timex.is_valid?("2018/06/04") == false)

  test "Timex is_valid String DateTime invalid",
    do: assert(Timex.is_valid?("2018-06-04 23:10:07") == false)

  test "Timex is_valid String Slash DateTime invalid",
    do: assert(Timex.is_valid?("2018/06/04 23:10:07") == false)

  test "Timex is_valid String DateTime TZ invalid",
    do: assert(Timex.is_valid?("2018-06-04T23:10:07Z") == false)

  test "Timex is_valid Tuple Date invalid", do: assert(Timex.is_valid?({{2010, 1, 13}}) == false)

  # 	test "Timex is_valid Time invalid",                  do: assert Timex.is_valid?( ~T[23:10:07.005000] ) == false
end

defmodule PrimitiveFunctionTest do
  use PowerAssert

  test "call by value", do: assert(Receiver.by_value("by value") == "This is value by value")

  test "call by local function",
    do:
      assert(TestCall.by_function(&local_function/1) == "This is local function call by function")

  def local_function(value), do: "This is local function #{value}"

  test "call by other module function",
    do:
      assert(
        TestCall.by_function(&Receiver.module_function/1) ==
          "This is other module function call by function"
      )

  test "call by other module",
    do: assert(TestCall.by_module(Receiver) == "This is value call by value via module")
end

defmodule TestCall do
  def by_function(function), do: "call by function" |> function.()
  def by_module(module), do: "call by value via module" |> module.by_value
end

defmodule Receiver do
  def by_value(value), do: "This is value #{value}"
  def module_function(value), do: "This is other module function #{value}"
end
