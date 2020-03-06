defmodule(Jaeger.Thrift.Generated.Dependency.Handler) do
  @moduledoc false
  (
    @callback get_dependencies_for_trace(trace_id :: String.t()) ::
                %Jaeger.Thrift.Generated.Dependencies{}
    @callback save_dependencies(dependencies :: %Jaeger.Thrift.Generated.Dependencies{}) ::
                no_return()
  )
end
