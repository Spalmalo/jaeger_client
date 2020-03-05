defmodule JaegerClient.SpanContext do
  @moduledoc """
  Jaeger SpanContext module
  """

  @type t :: %__MODULE__{
          trace_id: trace_id(),
          span_id: span_id(),
          parent_id: span_id(),
          baggage: %{optional(binary) => binary},
          sampling_state: nil,
          debug_id: binary,
          remote: boolean
        }

  defstruct trace_id: nil,
            span_id: nil,
            parent_id: nil,
            baggage: %{},
            sampling_state: nil,
            debug_id: "",
            remote: false

  def sampled?(%__MODULE__{} = context)

  def debug?(%__MODULE__{})

  def sampling_finalized?(%__MODULE__{})

  def firehouse?(%__MODULE__{})

  def valid?(%__MODULE__{})

  def to_string(%__MODULE__{})

  def copy_from(%__MODULE__{} = to, %__MODULE__{} = from)

  def with_baggage_item(%__MODULE__{}, key, value)

  @doc """
  Reconstructs the Context encoded in a string
  """
  @spec from_string(binary) :: {:ok, t()} | {:error, term}
  def from_string(value)
end
