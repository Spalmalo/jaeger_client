defmodule JaegerClient.UtilsTest do
  use ExUnit.Case

  alias JaegerClient.Utils

  test "parse_int_16!/1 correctly parses input" do
    assert 255 == Utils.parse_int_16!("ff")
    assert 1 == Utils.parse_int_16!("1")
    assert 1 == Utils.parse_int_16!("001")

    assert catch_error(Utils.parse_int_16!("x"))
    assert catch_error(Utils.parse_int_16!("0_01"))
    assert catch_error(Utils.parse_int_16!("0_1"))
  end

  test "int_16_to_string/1 correctly converts input to string" do
    assert "00000000000000ff" == Utils.int_16_to_string(255)
    assert "0000000000000001" == Utils.int_16_to_string(1)
  end

  test "parse_int_10!/1 correctly parses input" do
    assert 11 == Utils.parse_int_10!("11")
    assert 1 == Utils.parse_int_10!("1")
    assert 1 == Utils.parse_int_10!("001")

    assert catch_error(Utils.parse_int_10!("x"))
    assert catch_error(Utils.parse_int_10!("0_01"))
    assert catch_error(Utils.parse_int_10!("0_1"))
  end

  test "int_10_to_string/1 correctly converts input to string" do
    assert "255" == Utils.int_10_to_string(255)
    assert "11" == Utils.int_10_to_string(11)
    assert "1" == Utils.int_10_to_string(1)
  end

  test "to_trace_id!/1 create correct trace ids" do
    assert {0, 0} == Utils.to_trace_id!("0")
    assert {0, 0} == Utils.to_trace_id!("0000000000000000")

    assert {81_985_529_205_302_085, 7_460_495_508_715_833_601} ==
             Utils.to_trace_id!("01234567890123456789012345678901")

    # too big trace_id
    assert catch_error(Utils.to_trace_id!("01234567890123456789012345678901234"))
    # Have _ in numbers
    assert catch_error(Utils.to_trace_id!("01234_67890123456789012345678901"))
    # Have _ in numbers
    assert catch_error(Utils.to_trace_id!("0123456789012345678901_345678901"))
  end

  test "trace_id_to_string!/1 converts trace_id to string" do
    assert "0000000000000000" == Utils.trace_id_to_string!({0, 0})
    assert "0000000000000001" == Utils.trace_id_to_string!({0, 1})
    assert "00000000000000010000000000000001" == Utils.trace_id_to_string!({1, 1})
    assert "00000000000000ff00000000000000ff" == Utils.trace_id_to_string!({255, 255})
  end

  test "trace_id_valid?/1" do
    assert Utils.trace_id_valid?({1, 0})
    assert Utils.trace_id_valid?({0, 1})
    assert Utils.trace_id_valid?({1, 1})
    assert Utils.trace_id_valid?({1, 255})

    refute Utils.trace_id_valid?({0, 0})
  end

  test "to_span_id!/1 correctly converts binary to span_id" do
    assert 0 == Utils.to_span_id!("0")
    assert 0 == Utils.to_span_id!("000000000")
    assert 0 == Utils.to_span_id!("0000000000000000")
    # too big length
    assert catch_error(Utils.to_span_id!("00000000000000000"))

    assert 1 == Utils.to_span_id!("1")
    assert 1 == Utils.to_span_id!("0000000001")
    assert 1 == Utils.to_span_id!("0000000000000001")
    # too big length
    assert catch_error(Utils.to_span_id!("00000000000000000"))

    assert 255 == Utils.to_span_id!("ff")
    assert 255 == Utils.to_span_id!("00000000ff")
    assert 255 == Utils.to_span_id!("00000000000000ff")
    # too big length
    assert catch_error(Utils.to_span_id!("0000000000000000ff"))
  end

  test "span_id_to_string!/1 converts trace_id to string" do
    assert "0000000000000000" == Utils.span_id_to_string!(0)
    assert "0000000000000001" == Utils.span_id_to_string!(1)
    assert "00000000000000ff" == Utils.span_id_to_string!(255)
  end

  test "span_id_valid?/1" do
    assert Utils.span_id_valid?(1)
    assert Utils.span_id_valid?(255)

    refute Utils.span_id_valid?(0)
  end
end
