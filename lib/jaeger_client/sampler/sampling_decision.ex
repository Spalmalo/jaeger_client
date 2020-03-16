defmodule JaegerClient.Sampler.SamplingDecision do
  @moduledoc """
  Sampler methods return SamplingDecision struct.
  """

  alias JaegerClient.Span
  alias JaegerClient.SpanContext

  @typedoc """
  Sampling decision
  """
  @type t :: %__MODULE__{
          sample: boolean,
          retryable: boolean,
          tags: %{optional(binary) => term}
        }

  defstruct sample: false, retryable: false, tags: %{}

  @doc """
  Apply a sampling decision to a given span
  """
  @spec apply_to_span(Span.t(), t()) :: Span.t()
  def apply_to_span(%Span{context: context} = span, %__MODULE__{
        retryable: retryable,
        sample: sample,
        tags: tags
      }) do
    context =
      context
      |> apply_retryable(retryable)
      |> apply_sample(sample)

    %Span{span | context: context}
    |> Span.append_tags(tags)
  end

  defp apply_retryable(%SpanContext{} = context, true),
    do: context

  defp apply_retryable(%SpanContext{} = context, false),
    do: SpanContext.finalize_sampling(context)

  defp apply_sample(%SpanContext{} = context, true),
    do: SpanContext.set_sampled(context, true)

  defp apply_sample(%SpanContext{} = context, false),
    do: context
end
