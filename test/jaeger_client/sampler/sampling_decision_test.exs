defmodule JaegerClient.Sampler.SamplingDecisionTest do
  use ExUnit.Case

  alias JaegerClient.SpanContext
  alias JaegerClient.Sampler.SamplingDecision
  alias JaegerClient.Test.Support.Helper

  test "apply_to_span/2 applies new sampling decision to given span" do
    span = Helper.new_span()

    tags = %{"test" => Faker.String.base64()}

    decision = %SamplingDecision{
      sample: true,
      retryable: false,
      tags: tags
    }

    refute SpanContext.sampling_finalized?(span.context)
    refute SpanContext.sampled?(span.context)

    updated_span = SamplingDecision.apply_to_span(span, decision)

    assert SpanContext.sampling_finalized?(updated_span.context)
    assert SpanContext.sampled?(updated_span.context)

    assert Helper.has_tags?(updated_span, tags)
  end
end
