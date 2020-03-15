defmodule JaegerClient.Ext.Tags do
  @moduledoc """
  List of predefined tags for Jaeger/Opentracing
  """

  @sampling_priority "sampling.priority"

  @doc """
  SAMPLING_PRIORITY (number) determines the priority of sampling this Span.
  If greater than 0, a hint to the Tracer to do its best to capture the trace.
  If 0, a hint to the trace to not-capture the trace. If absent, the Tracer
  should use its default sampling mechanism.
  """
  @spec sampling_priority() :: binary
  def sampling_priority(),
    do: @sampling_priority
end
