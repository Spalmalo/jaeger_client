defmodule JaegerClient.SpanContextTest do
  use ExUnit.Case

  alias JaegerClient.SpanContext
  alias JaegerClient.SamplingState

  test "from_string/1 parsing test" do
    assert catch_error(SpanContext.from_string!(""))
    assert catch_error(SpanContext.from_string!("abcd"))
    assert catch_error(SpanContext.from_string!("x:1:1:1"))
    assert catch_error(SpanContext.from_string!("1:x:1:1"))
    assert catch_error(SpanContext.from_string!("1:1:x:1"))
    assert catch_error(SpanContext.from_string!("1:1:1:x"))
    assert catch_error(SpanContext.from_string!("1:1:1:x"))

    # too big trace_id
    assert catch_error(SpanContext.from_string!("01234567890123456789012345678901234:1:1:1"))
    # Everything ok
    assert SpanContext.from_string!("01234567890123456789012345678901:1:1:1")
    # Have _ in numbers
    assert catch_error(SpanContext.from_string!("01234_67890123456789012345678901:1:1:1"))
    # Have _ in numbers
    assert catch_error(SpanContext.from_string!("0123456789012345678901_345678901:1:1:1"))

    assert SpanContext.from_string!("1:0123456789012345:1:1")
    # too big span_id
    assert catch_error(SpanContext.from_string!("1:01234567890123456:1:1"))

    assert %SpanContext{trace_id: {1, 1}} = SpanContext.from_string!("10000000000000001:1:1:1")

    assert %SpanContext{trace_id: {0, 1}, span_id: 1, parent_id: 1} =
             ctx = SpanContext.from_string!("1:1:1:1")

    assert SpanContext.sampled?(ctx) == true

    ctx = SpanContext.from_string!("1:1:1:0")
    assert SpanContext.sampled?(ctx) == false
  end

  test "with_baggage_item/3 adds baggage items correctly" do
    ctx = SpanContext.with_baggage_item(%SpanContext{}, "some-KEY", "Some-Value")
    assert %SpanContext{baggage: %{"some-KEY" => "Some-Value"}} = ctx

    assert %SpanContext{baggage: %{"some-KEY" => "Some-Other-Value"}} =
             SpanContext.with_baggage_item(ctx, "some-KEY", "Some-Other-Value")
  end

  test "valid?/1 checks span context correctly" do
    assert SpanContext.valid?(%SpanContext{trace_id: {1, 1}, span_id: 1})
    assert SpanContext.valid?(%SpanContext{trace_id: {0, 1}, span_id: 1})
    assert SpanContext.valid?(%SpanContext{trace_id: {1, 0}, span_id: 1})
    assert SpanContext.valid?(%SpanContext{trace_id: {1, 1}, span_id: 1, parent_id: 0})
    assert SpanContext.valid?(%SpanContext{trace_id: {1, 1}, span_id: 1, parent_id: 1})

    refute SpanContext.valid?(%SpanContext{trace_id: {0, 0}, span_id: 1})
    refute SpanContext.valid?(%SpanContext{trace_id: {0, 1}, span_id: 0})
  end

  test "copy_from/1 correctly sets values to new context" do
    ctx = SpanContext.from_string!("1:1:1:1")

    assert %SpanContext{trace_id: {0, 1}, span_id: 1, parent_id: 1} =
             SpanContext.copy_from(%SpanContext{}, ctx)

    baggage = %{"some-KEY" => "Some-Value"}

    assert %SpanContext{trace_id: {0, 1}, span_id: 1, parent_id: 1, baggage: ^baggage} =
             SpanContext.copy_from(%SpanContext{}, %SpanContext{ctx | baggage: baggage})
  end

  test "state_flags testing" do
    # Custom fn for testing
    check_flags = fn str, sampled, debug, firehose ->
      %SpanContext{} = ctx = SpanContext.from_string!(str)

      assert sampled == SpanContext.sampled?(ctx),
             "wrong sampled [#{inspect(sampled)}] reuslt for #{str}"

      assert debug == SpanContext.debug?(ctx), "wrong debug [#{inspect(debug)}] reuslt for #{str}"

      assert firehose == SpanContext.firehose?(ctx),
             "wrong firehose [#{inspect(firehose)}] reuslt for #{str}"
    end

    check_flags.("1:1:1:0", false, false, false)
    check_flags.("1:1:1:1", true, false, false)
    check_flags.("1:1:1:2", false, true, false)
    check_flags.("1:1:1:8", false, false, true)
    check_flags.("1:1:1:3", true, true, false)
    check_flags.("1:1:1:9", true, false, true)
    check_flags.("1:1:1:10", false, true, true)
    check_flags.("1:1:1:11", true, true, true)
  end

  test "finalize_sampling/1 should correctly finalize span context" do
    ctx = SpanContext.from_string!("1:1:1:0")

    refute SpanContext.sampling_finalized?(ctx)
    assert ctx |> SpanContext.finalize_sampling() |> SpanContext.sampling_finalized?()
  end

  test "set_sampled/1 should correctly set sampling flag" do
    ctx = SpanContext.from_string!("1:1:1:0")

    refute SpanContext.sampled?(ctx)
    assert ctx |> SpanContext.set_sampled() |> SpanContext.sampled?()

    refute ctx
           |> SpanContext.set_sampled()
           |> SpanContext.set_sampled(false)
           |> SpanContext.sampled?()
  end

  test "set_debug/1 should correctly set debug flag" do
    ctx = SpanContext.from_string!("1:1:1:0")

    refute SpanContext.debug?(ctx)
    assert ctx |> SpanContext.set_debug() |> SpanContext.debug?()

    refute ctx
           |> SpanContext.set_debug()
           |> SpanContext.set_debug(false)
           |> SpanContext.debug?()
  end

  test "set_firehose/1 should correctly set firehose flag" do
    ctx = SpanContext.from_string!("1:1:1:0")

    refute SpanContext.firehose?(ctx)
    assert ctx |> SpanContext.set_firehose() |> SpanContext.firehose?()

    refute ctx
           |> SpanContext.set_firehose()
           |> SpanContext.set_firehose(false)
           |> SpanContext.firehose?()
  end

  test "new_from_parent/1 should correctly create new context from given parent" do
    ctx =
      "1:1:1:1"
      |> SpanContext.from_string!()
      |> SpanContext.with_baggage_item("Key", "Val")

    refute ctx.remote

    new_ctx = SpanContext.new_from_parent(ctx)

    assert new_ctx.trace_id == ctx.trace_id
    assert new_ctx.baggage == ctx.baggage
    assert new_ctx.parent_id == ctx.span_id

    refute new_ctx.span_id == ctx.span_id
    refute SamplingState.final?(new_ctx.sampling_state)

    # Check with remote parent span
    new_ctx = SpanContext.new_from_parent(%SpanContext{ctx | remote: true})

    assert new_ctx.trace_id == ctx.trace_id
    assert new_ctx.baggage == ctx.baggage
    assert new_ctx.parent_id == ctx.span_id

    refute new_ctx.span_id == ctx.span_id

    assert SamplingState.final?(new_ctx.sampling_state)
    assert new_ctx.sampling_state.local_root_span == new_ctx.span_id
  end
end
