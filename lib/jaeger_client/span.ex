defmodule JaegerClient.Span do
  @moduledoc """
  Span implements opentracing Span.
  """

  alias JaegerClient.SpanContext

  @typedoc """
  `tracer`
    TBD

  `context`
    Span context.

  `operation_name`
    The name of the "operation" this span is an instance of.
    Known as a "span name" in some implementations.

  `start_time`
    The timestamp indicating when the span began, with microseconds precision.

  `duration`
    Returns duration of the span with microseconds precision.
    Zero value means duration is unknown.

  `tags`
    Tags attached to this span

  `logs`
    The span's "micro-log"

  `references`
    References for this span
  """
  @type t :: %__MODULE__{
          tracer: nil,
          context: SpanContext.t(),
          operation_name: binary,
          start_time: non_neg_integer,
          duration: non_neg_integer,
          tags: %{optional(binary) => term},
          logs: [],
          references: []
        }

  defstruct tracer: nil,
            context: nil,
            operation_name: "",
            start_time: 0,
            duration: 0,
            tags: %{},
            logs: [],
            references: []
end
