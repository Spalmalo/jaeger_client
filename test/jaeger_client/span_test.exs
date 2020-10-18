defmodule JaegerClient.SpanTest do
  use ExUnit.Case

  alias JaegerClient.Span
  alias JaegerClient.SpanContext
  alias JaegerClient.Ext.Tags
  alias JaegerClient.Test.Support.Helper

  test "new/1 creates correct spans" do
    name = Faker.String.base64()
    assert %Span{operation_name: ^name} = Span.new(name, SpanContext.new())

    assert catch_error(%Span{operation_name: ^name} = Span.new(name <> "1", SpanContext.new()))

    %Span{start_time: time} = Span.new(name, SpanContext.new())
    assert time > 0
  end

  test "set_operation_name/2 sets or changes name" do
    name = Faker.String.base64()

    span =
      "test"
      |> Span.new(SpanContext.new())
      |> Span.set_operation_name(name)

    assert name == span.operation_name

    updated_name = Faker.String.base64()
    assert %Span{operation_name: ^updated_name} = Span.set_operation_name(span, updated_name)
  end

  test "set debug and sampling flags through sampling priority via set_tag/3" do
    span =
      Helper.new_span()
      |> Span.set_tag(Tags.sampling_priority(), 3)

    assert SpanContext.debug?(span.context)
    assert SpanContext.sampled?(span.context)

    assert Helper.has_tags?(span, %{Tags.sampling_priority() => 3})
  end

  test "set debug and sampling flags through sampling priority via add_tags/2" do
    tags = %{Tags.sampling_priority() => 3}

    span =
      Helper.new_span()
      |> Span.add_tags(tags)

    assert SpanContext.debug?(span.context)
    assert SpanContext.sampled?(span.context)

    assert Helper.has_tags?(span, %{Tags.sampling_priority() => 3})
  end

  test "unset sampling on span via sampling priority" do
    span =
      Helper.new_span()
      |> Span.set_tag(Tags.sampling_priority(), 0)

    refute SpanContext.sampled?(span.context)
  end

  test "add new tags" do
    tags = %{
      "num-tag" => 1,
      "string-tag" => "string",
      "bool-tag" => true
    }

    span =
      Helper.new_span()
      |> Span.add_tags(tags)
      |> Span.set_tag("num-tag", 2)

    assert Helper.has_tags?(span, tags)

    assert 4 ==
             span
             |> Map.get(:tags)
             |> length()

    assert 2 ==
             span
             |> Map.get(:tags)
             |> Enum.filter(fn %{key: key} -> key == "num-tag" end)
             |> length()
  end
end
