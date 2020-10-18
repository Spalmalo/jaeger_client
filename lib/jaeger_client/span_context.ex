defmodule JaegerClient.SpanContext do
  @moduledoc """
  Jaeger SpanContext module.
  Represents propagated span identity and state.
  """

  alias JaegerClient.SamplingState
  alias JaegerClient.Utils

  @typedoc """
  Structure represents propagated span identity and state.

  `trace_id`
    Represents globally unique ID of the trace.
    Usually generated as a random number.

  `span_id`
    Represents span ID that must be unique within its trace,
    but does not have to be globally unique.

  `parent_id`
    Refers to the ID of the parent span.
    Should be 0 if the current span is a root span.

  `baggage`
    Distributed Context baggage. The is a snapshot in time.

  `sampling_state`
    `JaegerClient.SamplingState.t()` shared across all spans.

  `debug_id`
    Can be set to some correlation ID when the context is being
    extracted from a TextMap carrier.

  `remote`
    Indicates that span context represents a remote parent.
  """
  @type t :: %__MODULE__{
          trace_id: JaegerClient.trace_id(),
          span_id: JaegerClient.span_id(),
          parent_id: JaegerClient.span_id(),
          baggage: %{optional(binary) => binary},
          sampling_state: nil,
          debug_id: binary,
          remote: boolean
        }

  defstruct trace_id: 0,
            span_id: 0,
            parent_id: 0,
            baggage: %{},
            sampling_state: nil,
            debug_id: "",
            remote: false

  @doc """
  Creates new `SpanContext` with given sampling state.
  By default if no `sampling_state` given, new one will be created.
  """
  @spec new(SamplingState.t()) :: t()
  def new(sampling_state \\ %SamplingState{}),
    do: %__MODULE__{
      sampling_state: sampling_state
    }

  @doc """
  Generate new Span context created from parent `SpanContext.t()`.
  """
  @spec new_from_parent(t()) :: t()
  def new_from_parent(
        %__MODULE__{trace_id: trace_id, span_id: span_id, baggage: baggage} = parent
      ) do
    new_span_id = Utils.random_id()

    %__MODULE__{
      trace_id: trace_id,
      span_id: new_span_id,
      parent_id: span_id,
      sampling_state: sampling_state_from_parent(new_span_id, parent),
      baggage: baggage
    }
  end

  @doc """
  Returns whether this trace was chosen for permanent storage
  by the sampling mechanism of the tracer.
  """
  @spec sampled?(t()) :: boolean
  def sampled?(%__MODULE__{sampling_state: sampling_state}),
    do: SamplingState.sampled?(sampling_state)

  @doc """
  Indicates whether sampling was explicitly requested by the service.
  """
  @spec debug?(t()) :: boolean
  def debug?(%__MODULE__{sampling_state: sampling_state}),
    do: SamplingState.debug?(sampling_state)

  @doc """
  Indicates whether the firehose flag was set.
  """
  @spec firehose?(t()) :: boolean
  def firehose?(%__MODULE__{sampling_state: sampling_state}),
    do: SamplingState.firehose?(sampling_state)

  @doc """
  Indicates whether the sampling decision has been finalized.
  """
  @spec sampling_finalized?(t()) :: boolean
  def sampling_finalized?(%__MODULE__{sampling_state: sampling_state}),
    do: SamplingState.final?(sampling_state)

  @doc """
  Indicates whether this context actually represents a valid trace.
  """
  @spec valid?(t()) :: boolean
  def valid?(%__MODULE__{trace_id: trace_id, span_id: span_id, parent_id: 0}),
    do: Utils.trace_id_valid?(trace_id) && Utils.span_id_valid?(span_id)

  def valid?(%__MODULE__{trace_id: trace_id, span_id: span_id, parent_id: parent_id}),
    do:
      Utils.trace_id_valid?(trace_id) && Utils.span_id_valid?(span_id) &&
        Utils.span_id_valid?(parent_id)

  @doc """
  Finalizes sampling in sampling state
  """
  @spec finalize_sampling(t()) :: t()
  def finalize_sampling(%__MODULE__{sampling_state: sampling_state} = ctx),
    do: %__MODULE__{ctx | sampling_state: SamplingState.set_final(sampling_state, true)}

  @doc """
  Set sampling flag for internal sampling_state
  """
  @spec set_sampled(t(), boolean) :: t()
  def set_sampled(%__MODULE__{sampling_state: sampling_state} = ctx, enable \\ true),
    do: %__MODULE__{ctx | sampling_state: SamplingState.set_sampled(sampling_state, enable)}

  @doc """
  Set debug flag for internal sampling_state
  """
  @spec set_debug(t(), boolean) :: t()
  def set_debug(%__MODULE__{sampling_state: sampling_state} = ctx, enable \\ true),
    do: %__MODULE__{ctx | sampling_state: SamplingState.set_debug(sampling_state, enable)}

  @doc """
  Set firehose flag for internal sampling_state
  """
  @spec set_firehose(t(), boolean) :: t()
  def set_firehose(%__MODULE__{sampling_state: sampling_state} = ctx, enable \\ true),
    do: %__MODULE__{ctx | sampling_state: SamplingState.set_firehose(sampling_state, enable)}

  @doc """
  Converts goven `JaegerClient.SpanContext.t()` to it's binary representation.
  """
  @spec to_string(t()) :: binary
  def to_string(%__MODULE__{
        trace_id: trace_id,
        span_id: span_id,
        parent_id: parent_id,
        sampling_state: %SamplingState{state_flags: flags}
      }) do
    "#{Utils.trace_id_to_string!(trace_id)}:#{Utils.span_id_to_string!(span_id)}:#{
      Utils.span_id_to_string!(parent_id)
    }:#{Utils.int_10_to_string(flags)}"
  end

  @doc """
  Creates a new context with an extra baggage item.
  """
  @spec with_baggage_item(t(), binary, binary) :: t()
  def with_baggage_item(%__MODULE__{baggage: baggage} = ctx, key, value),
    do: %__MODULE__{ctx | baggage: Map.put(baggage, key, value)}

  @doc """
  Merges data from both given contexts into new one, including span identity and baggage.
  """
  @spec copy_from(t(), t()) :: t()
  def copy_from(%__MODULE__{baggage: baggage} = ctx1, %__MODULE__{} = ctx2) do
    ctx = Map.merge(ctx1, ctx2)
    %__MODULE__{ctx | baggage: Map.merge(ctx.baggage, baggage)}
  end

  @doc """
  Reconstructs the Context encoded in a string
  In case of some issues error will be risen
  """
  @spec from_string!(binary) :: t()
  def from_string!(""),
    do: raise(ArgumentError, message: "wrong input string for extracting span_context")

  def from_string!(value) do
    [trace_id_low, span_id, parent_span_id, bits] = String.split(value, ":")

    %__MODULE__{
      trace_id: Utils.to_trace_id!(trace_id_low),
      span_id: Utils.to_span_id!(span_id),
      parent_id: Utils.to_span_id!(parent_span_id),
      sampling_state: %SamplingState{state_flags: Utils.parse_int_10!(bits)}
    }
  end

  @doc false
  @spec debug_id_container_only?(t()) :: boolean
  def debug_id_container_only?(%__MODULE__{debug_id: ""}),
    do: false

  def debug_id_container_only?(%__MODULE__{debug_id: debug_id} = ctx),
    do: !valid?(ctx)

  # Checks if parent span is `remote`. And if it is does `sampling_state` finalization.
  defp sampling_state_from_parent(span_id, %__MODULE__{
         sampling_state: sampling_state,
         remote: remote
       }) do
    case remote do
      true ->
        %SamplingState{sampling_state | local_root_span: span_id}
        |> SamplingState.set_final(true)

      false ->
        sampling_state
    end
  end
end
