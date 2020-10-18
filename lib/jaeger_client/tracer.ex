defmodule JaegerClient.Tracer do
  @moduledoc """
  Tracer implementation
  """

  alias JaegerClient.Span
  alias JaegerClient.SpanContext
  alias JaegerClient.SamplingState
  alias JaegerClient.Utils

  @typedoc "Start span option list."
  @type start_span_options :: [start_span_option]

  @typedoc """
  Available options for starting new span.

  `start_time`
  Overrides the Span's start time, or implicitly becomes `JaegerClient.Utils.current_time/0` if not passed.

  `references`
  Zero or more causal references to other Spans (via their `JaegerClient.SpanContext`).
  If empty, start a "root" Span (i.e., start a new trace).

  `tags`
  Tags may have zero or more entries; the restrictions on map values are
  identical to those for `JaegerClient.Span.set_tag/3`.

  If specified, the caller hands off ownership of Tags at
  `start_span/2` invocation time.
  """
  @type start_span_option ::
          {:start_time, pos_integer}
          | {:references, [Span.ref()]}
          | {:tags, [Span.tag()]}

  @doc """
  Create, start, and return a new Span with the given `operation_name` and
  incorporate the given `opts`.

  A Span with no `Span.ref()` option becomes the root of its own trace.
  """
  @spec start_span(binary, start_span_options()) :: Span.t()
  def start_span(operation_name, opts \\ []) do
    case Keyword.pop(opts, :references) do
      {nil, _} ->
        # start new span without references
        {_, low_id} = trace_id = Utils.random_trace_id()

        ctx = %SpanContext{
          trace_id: trace_id,
          span_id: low_id,
          sampling_state: %SamplingState{
            local_root_span: low_id
          }
        }

        %Span{
          context: ctx,
          operation_name: operation_name,
          start_time: Keyword.get(opts, :start_time, Utils.current_time())
        }

      {refs, _} ->
        # Start new span with refs
        :ok
    end
  end
end
