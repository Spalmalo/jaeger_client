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
end
