defmodule JaegerClient.SamplingStateTest do
  use ExUnit.Case

  alias JaegerClient.SamplingState

  test "state_flags test" do
    assert SamplingState.sampled?(%SamplingState{state_flags: 1})
    assert SamplingState.sampled?(%SamplingState{state_flags: 9})
    assert SamplingState.sampled?(%SamplingState{state_flags: 11})

    assert SamplingState.debug?(%SamplingState{state_flags: 2})
    assert SamplingState.debug?(%SamplingState{state_flags: 10})
    assert SamplingState.debug?(%SamplingState{state_flags: 11})

    assert SamplingState.firehose?(%SamplingState{state_flags: 8})
    assert SamplingState.firehose?(%SamplingState{state_flags: 10})
    assert SamplingState.firehose?(%SamplingState{state_flags: 11})
  end

  test "set_flags/1 set new flags" do
    assert %SamplingState{state_flags: 1} = SamplingState.set_flags(%SamplingState{}, 1)
    assert %SamplingState{state_flags: 2} = SamplingState.set_flags(%SamplingState{}, 2)
    assert %SamplingState{state_flags: 8} = SamplingState.set_flags(%SamplingState{}, 8)
  end

  test "local_root_span?/2 checks spans correctly" do
    assert SamplingState.local_root_span?(%SamplingState{local_root_span: 1}, 1)
    assert SamplingState.local_root_span?(%SamplingState{local_root_span: 255}, 255)

    refute SamplingState.local_root_span?(%SamplingState{local_root_span: 1}, 255)
    refute SamplingState.local_root_span?(%SamplingState{}, 1)
  end

  test "final?/1 check if state is finilized" do
    assert SamplingState.final?(%SamplingState{final: true})
    refute SamplingState.final?(%SamplingState{final: false})
  end

  test "set_final/2 correctly sets final flag" do
    state = %SamplingState{}
    assert state |> SamplingState.set_final(true) |> SamplingState.final?()
    refute state |> SamplingState.set_final(false) |> SamplingState.final?()
  end

  test "set_sampled/1 correctly sets flags" do
    state = %SamplingState{}
    refute SamplingState.sampled?(state)

    assert state
           |> SamplingState.set_sampled()
           |> SamplingState.sampled?()

    refute state
           |> SamplingState.set_sampled()
           |> SamplingState.set_sampled(false)
           |> SamplingState.sampled?()
  end

  test "set_debug/1 correctly sets flags" do
    state = %SamplingState{}
    refute SamplingState.debug?(state)

    assert state
           |> SamplingState.set_debug()
           |> SamplingState.debug?()

    refute state
           |> SamplingState.set_debug()
           |> SamplingState.set_debug(false)
           |> SamplingState.debug?()
  end

  test "set_firehose/1 correctly sets flags" do
    state = %SamplingState{}
    refute SamplingState.firehose?(state)

    assert state
           |> SamplingState.set_firehose()
           |> SamplingState.firehose?()

    refute state
           |> SamplingState.set_firehose()
           |> SamplingState.set_firehose(false)
           |> SamplingState.firehose?()
  end
end
