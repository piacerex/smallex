defmodule Crypt do
  @moduledoc """
  Crypt utiity.
  """

  @doc """
  Generate md5

  ## Examples
      iex> Crypt.md5("test")
      "098f6bcd4621d373cade4e832627b4f6"
      iex> Crypt.md5("test2")
      "ad0234829205b9033196ba818f7a872b"
  """
  def md5(input), do: :crypto.hash(:md5, input) |> Base.encode16(case: :lower)

  @doc """
  Generate sha256

  ## Examples
      iex> Crypt.sha256("test", "secret")
      "0329a06b62cd16b33eb6792be8c60b158d89a2ee3a876fce9a881ebb488c0914"
      iex> Crypt.sha256("test2", "secret2")
      "35a766d5ff5d090e28166313461f38e738081d16449fa834102fc10beb2495f7"
  """
  def sha256(input, secret),
    do: :crypto.hmac(:sha256, secret, input) |> Base.encode16(case: :lower)

  @doc """
  List usable crypts

  ## Examples
      iex> Crypt.list_usable().hashs
      [:sha, :sha224, :sha256, :sha384, :sha512, :sha3_224, :sha3_256, :sha3_384, :sha3_512, :blake2b, :blake2s, :md4, :md5, :ripemd160]
      iex> Crypt.list_usable( :hashs )
      [hashs: [:sha, :sha224, :sha256, :sha384, :sha512, :sha3_224, :sha3_256,:sha3_384, :sha3_512, :blake2b, :blake2s, :md4, :md5, :ripemd160]]
      iex> Crypt.list_usable( "hash" )
      [hashs: [:sha, :sha224, :sha256, :sha384, :sha512, :sha3_224, :sha3_256, :sha3_384, :sha3_512, :blake2b, :blake2s, :md4, :md5, :ripemd160]]
  """
  def list_usable(),
    do: :crypto.supports() |> Enum.reduce(%{}, &(&2 |> Map.put(elem(&1, 0), elem(&1, 1))))

  def list_usable(match) when is_atom(match) do
    :crypto.supports()
    |> Enum.filter(
      &(elem(&1, 0) == match ||
          Enum.find(elem(&1, 1), fn n -> n == match end))
    )
  end

  def list_usable(match) when is_binary(match) do
    lower_match = String.downcase(match)

    :crypto.supports()
    |> Enum.filter(
      &(String.contains?(Atom.to_string(elem(&1, 0)), lower_match) ||
          Enum.find(elem(&1, 1), fn n -> String.contains?(Atom.to_string(n), lower_match) end))
    )
  end

  @doc """
  Make hmac sign

  ## Examples
      iex> Crypt.make_hmac_sign("post", "https://api.github.com", "/rate_limit") |> String.slice( 22, 100 )
      "posthttps://api.github.com/rate_limit"
  """
  def make_hmac_sign(method, path, body), do: "#{timestamp()}#{method}#{path}#{body}"

  @doc """
  Make hmac sign

  ## Examples
      iex> Crypt.timestamp |> String.replace( ~r/[0-9]*/, "X" )
      "XX-XX-XXTXX:XX:XX.XX"
  """
  def timestamp(), do: Timex.now() |> Dt.to_string("%Y-%m-%dT%H:%M:%S.%L") |> String.slice(0, 22)
end
