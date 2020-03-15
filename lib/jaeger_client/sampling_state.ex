defmodule JaegerClient.SamplingState do
  @moduledoc """
  Sampler state that lives in `JaegerClient.SpanContext.t()` structure.
  """

  use Bitwise

  # is the bit mask indicating that a span has been sampled.
  @flag_sampled 1
  # is the bit mask indicating that a span has been marked for debug.
  @flag_debug 2

  # 0x4 is reserved for deferred sampling in the future
  # @flagReserved 4

  # is the bit mask indicating a span is a firehose span.
  @flag_firehose 8

  @typedoc """
  SamplerState structure:
  `state_flags`
    Shared Flags from span context

  `final`
    When state is not final, sampling will be retried on other write operations,
    and spans will remain writable.

    This field exists to help distinguish between when a span can have a properly
    correlated operation name -> sampling rate mapping, and when it cannot.
    Adaptive sampling uses the operation name of a span to correlate it with
    a sampling rate.  If an operation name is set on a span after the span's creation
    then adaptive sampling cannot associate the operation name with the proper sampling rate.
    In order to correct this we allow a span to be written to, so that we can re-sample
    it in the case that an operation name is set after span creation. Situations
    where a span context's sampling decision is finalized include:
    - it has inherited the sampling decision from its parent
    - its debug flag is set via the sampling.priority tag
    - it is finish()-ed
    - set_operation_name is called
    - it is used as a parent for another span
    - its context is serialized using injectors

  `local_root_span`
    Span ID of the local root span, i.e. the first span in this process for this trace.

  `extended_state`
    Samplers may store their individual states in this map.
  """
  @type t :: %__MODULE__{
          state_flags: non_neg_integer,
          final: boolean,
          local_root_span: JaegerClient.span_id(),
          extended_state: map
        }

  defstruct state_flags: 0, final: false, local_root_span: nil, extended_state: %{}

  @doc """
  Check if state has given pan_id
  """
  @spec local_root_span?(t(), JaegerClient.span_id()) :: boolean
  def local_root_span?(%__MODULE__{local_root_span: local_id}, span_id),
    do: local_id == span_id

  @doc """
  Set new state_flags for sampling state
  """
  @spec set_flags(t(), non_neg_integer) :: t()
  def set_flags(%__MODULE__{} = sampling_state, flags),
    do: %__MODULE__{sampling_state | state_flags: flags}

  @doc """
  Returns whether this trace was chosen for permanent storage
  by the sampling mechanism of the tracer.
  """
  @spec sampled?(t()) :: boolean
  def sampled?(%__MODULE__{state_flags: state_flags}),
    do: band(state_flags, @flag_sampled) == @flag_sampled

  @doc """
  Indicates whether sampling was explicitly requested by the service.
  """
  @spec debug?(t()) :: boolean
  def debug?(%__MODULE__{state_flags: state_flags}),
    do: band(state_flags, @flag_debug) == @flag_debug

  @doc """
  Indicates whether the firehose flag was set.
  """
  @spec firehose?(t()) :: boolean
  def firehose?(%__MODULE__{state_flags: state_flags}),
    do: band(state_flags, @flag_firehose) == @flag_firehose

  @doc """
  Indicates whether the sampling decision has been finalized.
  """
  @spec final?(t()) :: boolean
  def final?(%__MODULE__{final: final}),
    do: final

  @doc """
  Sets final property to given value
  """
  @spec set_final(t(), boolean) :: t()
  def set_final(%__MODULE__{} = sampling_state, value) when is_boolean(value),
    do: %__MODULE__{sampling_state | final: value}

  def set_final(sampling_state, _),
    do: sampling_state

  @doc """
  Sets sampled flag for a sampling_state.
  """
  @spec set_sampled(t(), boolean) :: t()
  def set_sampled(%__MODULE__{} = sampling_state, enable \\ true),
    do: toggle_flag(sampling_state, @flag_sampled, enable)

  @doc """
  Set debug flag flag for a sampling_state.
  """
  @spec set_debug(t(), boolean) :: t()
  def set_debug(%__MODULE__{} = sampling_state, enable \\ true),
    do: toggle_flag(sampling_state, @flag_debug, enable)

  @doc """
  Set firehose flag flag for a sampling_state.
  """
  @spec set_firehose(t(), boolean) :: t()
  def set_firehose(%__MODULE__{} = sampling_state, enable \\ true),
    do: toggle_flag(sampling_state, @flag_firehose, enable)

  # Toggle sampling_flags
  defp toggle_flag(%__MODULE__{state_flags: state_flags} = sampling_state, mask, true),
    do: %__MODULE__{sampling_state | state_flags: bor(state_flags, mask)}

  defp toggle_flag(%__MODULE__{state_flags: state_flags} = sampling_state, mask, false),
    do: %__MODULE__{sampling_state | state_flags: band(state_flags, bnot(mask))}
end
