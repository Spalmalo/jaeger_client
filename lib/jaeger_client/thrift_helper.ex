defmodule JaegerClient.ThriftHelper do
  @moduledoc """
  Thrift helper module.
  """

  alias JaegerClient.Span
  alias Jaeger.Thrift.Generated.Span, as: SpanThrift

  def to_thrift(%Span{} = span) do
    %SpanThrift{
      trace_id_low: nil,
      trace_id_high: nil,
      span_id: nil,
      parent_span_id: nil,
      operation_name: nil,
      references: nil,
      flags: nil,
      start_time: nil,
      duration: nil,
      tags: nil,
      logs: nil
    }
  end
end
