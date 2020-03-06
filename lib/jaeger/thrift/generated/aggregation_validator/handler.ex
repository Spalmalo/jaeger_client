defmodule(Jaeger.Thrift.Generated.AggregationValidator.Handler) do
  @moduledoc false
  @callback validate_trace(trace_id :: String.t()) ::
              %Jaeger.Thrift.Generated.ValidateTraceResponse{}
end
