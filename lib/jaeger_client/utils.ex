defmodule JaegerClient.Utils do
  @moduledoc """
  Utilities for Jaeger implementation.
  """

  @doc """
  Converts given binary to uint64

  Method is usefull for parsing trace/span ids from string.
  """
  @spec parse_int_16!(binary) :: non_neg_integer()
  def parse_int_16!(value) when is_binary(value) do
    {parsed, ""} =
      value
      |> String.upcase()
      |> Integer.parse(16)

    parsed
  end

  @doc """
  Converts given binary to uint16

  Method is usefull for parsing sampling flags.
  """
  @spec parse_int_10!(binary) :: non_neg_integer()
  def parse_int_10!(value) when is_binary(value) do
    {parsed, ""} =
      value
      |> String.upcase()
      |> Integer.parse(10)

    parsed
  end

  @doc """
  Converts given uint64 (for ex: span_id) to binary representation.
  """
  @spec int_16_to_string(non_neg_integer) :: binary
  def int_16_to_string(value) do
    value
    |> Integer.to_string(16)
    |> String.downcase()
    |> String.pad_leading(16, "0")
  end

  @doc """
  Converts given uint16 (for ex: sampling flags) to binary representation.
  """
  @spec int_10_to_string(non_neg_integer) :: binary
  def int_10_to_string(value) do
    value
    |> Integer.to_string(10)
    |> String.downcase()
  end

  @doc """
  Build correct trace if from given string.
  If string is empty or not contain real trace_id - `{0, 0}` will be returned.
  """
  @spec to_trace_id!(binary) :: JaegerClient.trace_id()
  def to_trace_id!(lo) when byte_size(lo) <= 16,
    do: {0, parse_int_16!(lo)}

  def to_trace_id!(value) when byte_size(value) <= 32 do
    hi_size = byte_size(value) - 16
    <<hi::binary-size(hi_size), lo::binary>> = value
    {parse_int_16!(hi), parse_int_16!(lo)}
  end

  def to_trace_id!(_),
    do: raise(ArgumentError, message: "wrong trace_id passed for parsing")

  @doc """
  Converts given trace_id to it's binary represantation.
  """
  @spec trace_id_to_string!(JaegerClient.trace_id()) :: binary
  def trace_id_to_string!({0, lo}),
    do: int_16_to_string(lo)

  def trace_id_to_string!({hi, lo}),
    do: int_16_to_string(hi) <> int_16_to_string(lo)

  def trace_id_to_string!(_),
    do: raise(ArgumentError, message: "wrong trace_id passed for stringifying")

  @doc """
  Checks if the trace ID is valid, i.e. not zero.
  """
  @spec trace_id_valid?(JaegerClient.trace_id()) :: boolean
  def trace_id_valid?({hi, lo}),
    do: hi > 0 || lo > 0

  @doc """
  Parse span_id from given string
  """
  @spec to_span_id!(binary) :: JaegerClient.span_id()
  def to_span_id!(id) when byte_size(id) <= 16,
    do: parse_int_16!(id)

  def to_span_id!(_),
    do: raise(ArgumentError, message: "wrong span_id passed for parsing")

  @doc """
  Converts span_id to it's binary representation.
  """
  @spec span_id_to_string!(JaegerClient.span_id()) :: binary
  def span_id_to_string!(id),
    do: int_16_to_string(id)

  @doc """
  Checks if the span ID is valid, i.e. not zero.
  """
  @spec span_id_valid?(JaegerClient.span_id()) :: boolean
  def span_id_valid?(id),
    do: id > 0
end
