defmodule JaegerClient.Test.Support.Helper do
  @moduledoc """
  Helper module for tests
  """

  alias JaegerClient.Span
  alias JaegerClient.SpanContext
  alias JaegerClient.SamplingState

  @doc """
  Generate new empty span context
  """
  @spec new_span_context() :: SpanContext.t()
  def new_span_context() do
    %SpanContext{
      sampling_state: %SamplingState{}
    }
  end

  @doc """
  Generate new correct `Span.t()` for tests
  """
  @spec new_span(binary) :: Span.t()
  def new_span(operation_name \\ "")

  def new_span(""),
    do: Span.new(Faker.String.base64(), new_span_context())

  def new_span(operation_name),
    do: Span.new(operation_name, new_span_context())

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
