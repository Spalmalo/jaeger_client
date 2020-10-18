defmodule JaegerClient.Test.Support.Helper do
  @moduledoc """
  Helper module for tests
  """

  alias JaegerClient.Span
  alias JaegerClient.SpanContext

  @doc """
  Generate new correct `Span.t()` for tests
  """
  @spec new_span(binary) :: Span.t()
  def new_span(operation_name \\ "")

  def new_span(""),
    do: new_span(Faker.String.base64())

  def new_span(operation_name),
    do: Span.new(operation_name)

  @doc """
  Checks if given `Span.t()` has all required tags with exact same values
  """
  @spec has_tags?(Span.t(), %{binary => term}) :: boolean
  def has_tags?(%Span{tags: tags}, required) when is_map(required) do
    0 ==
      required
      |> Enum.map(fn {k, v} -> Enum.member?(tags, %{key: k, value: v}) end)
      |> Enum.reject(fn r -> r == true end)
      |> length()
  end
end
