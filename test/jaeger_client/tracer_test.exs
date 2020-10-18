defmodule JaegerClient.TracerTest do
  use ExUnit.Case

  alias JaegerClient.Tracer
  alias JaegerClient.Span

  describe "start_span/2" do
    test "should start new span" do
      assert true
      refute false
    end
  end
end
