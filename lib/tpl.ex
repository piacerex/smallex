defmodule Tpl do
  @moduledoc """
  Tuple library.
  """

  @doc """
  Extract value on :ok

  ## Examples
    iex> { :ok, "success" } |> Tpl.ok
    "success"
  """
  def ok({:ok, result}), do: result

  @doc """
  Extract value on :error

  ## Examples
    iex> { :error, "error" } |> Tpl.error
    "error"
  """
  def error({:error, result}), do: result

  @doc """
  Extract value on :ok or :error

  ## Examples
    iex> { :ok, "success" } |> Tpl.both
    "success"
    iex> { :error, "error" } |> Tpl.both
    "error"
  """
  def both({:ok, result}), do: result
  def both({:error, result}), do: result
end
