defmodule JaegerClient.Span do
  @moduledoc """
  Span implements opentracing Span.
  """

  alias JaegerClient.SpanContext
  alias JaegerClient.Ext.Tags
  alias JaegerClient.Sampler.SamplingDecision

  # This is hack for ability to pattern match to this tag in function definition.
  @tag_sampling_priority Tags.sampling_priority()

  @typedoc """
  Tag is a simple key value wrapper for span.
  """
  @type tag :: %{key: binary, value: term}

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
          tags: [tag()],
          logs: [],
          references: []
        }

  defstruct tracer: nil,
            context: nil,
            operation_name: "",
            start_time: 0,
            duration: 0,
            tags: [],
            logs: [],
            references: []

  @doc """
  Creates new `Span` structure with given operation name.
  """
  @spec new(binary, SpanContext.t()) :: t()
  def new(operation_name, %SpanContext{} = ctx),
    do: %__MODULE__{operation_name: operation_name, context: ctx}

  @doc """
  Sets or changes the operation name.
  """
  @spec set_operation_name(t(), binary) :: t()
  def set_operation_name(%__MODULE__{context: context} = span, operation_name) do
    span = %__MODULE__{span | operation_name: operation_name}

    case SpanContext.sampling_finalized?(context) do
      true ->
        span

      false ->
        #   const decision = this.tracer()._sampler.onSetOperationName(this, operationName);
        #   this._applySamplingDecision(decision);
        span
    end
  end

  @doc """
  Implements SetTag() of opentracing.Span.
  Set new tag to SpanContext into given span.
  """
  @spec set_tag(t(), binary, term) :: t()
  def set_tag(%__MODULE__{} = span, key, value) do
    key
    |> case do
      @tag_sampling_priority ->
        set_sampling_priority(span, value)

      _ ->
        span
    end
    |> do_add_tags(%{key => value})
    |> finalize_sampling()
  end

  @doc """
  Adds a set of tags to a span.
  """
  @spec add_tags(t(), %{optional(binary) => term}) :: t()
  def add_tags(%__MODULE__{} = span, tags) do
    tags
    |> Map.get(@tag_sampling_priority)
    |> case do
      nil ->
        span

      value ->
        set_sampling_priority(span, value)
    end
    |> do_add_tags(tags)
    |> finalize_sampling()
  end

  def finish(%__MODULE__{}), do: :ok

  ######################################################
  # Private functions
  ######################################################

  # Checks whether or not a span can be written to.
  defp writable?(%__MODULE__{context: context}),
    do: !SpanContext.sampling_finalized?(context) || SpanContext.sampled?(context)

  # Returns updated span with required flags
  defp set_sampling_priority(%__MODULE__{context: nil} = span, _),
    do: span

  defp set_sampling_priority(%__MODULE__{context: context} = span, 0) do
    context =
      context
      |> SpanContext.set_sampled(false)
      |> SpanContext.set_debug(false)

    %__MODULE__{span | context: context}
  end

  defp set_sampling_priority(%__MODULE__{context: context} = span, _) do
    case SpanContext.debug?(context) do
      true ->
        span

      false ->
        # TODO: Check if tracer allowes debug mode
        context =
          context
          |> SpanContext.set_sampled()
          |> SpanContext.set_debug()

        %__MODULE__{span | context: context}
    end
  end

  defp set_sampling_priority(%__MODULE__{} = span, _),
    do: span

  # Add new tags without rewriginh old ones
  defp do_add_tags(%__MODULE__{tags: tags} = span, new_tags) when is_map(new_tags) do
    case writable?(span) do
      false ->
        span

      true ->
        updated =
          new_tags
          |> Enum.map(fn {k, v} -> %{key: k, value: v} end)

        %__MODULE__{span | tags: tags ++ updated}
    end
  end

  # Finalizes sampling_state if it's not yet finalized.
  defp finalize_sampling(%__MODULE__{context: context} = span) do
    case SpanContext.sampling_finalized?(context) do
      true ->
        span

      false ->
        # TODO: apply new decision
        # const decision = this._tracer._sampler.onSetTag(this, key, value);
        # this._applySamplingDecision(decision);
        span
    end
  end
end
