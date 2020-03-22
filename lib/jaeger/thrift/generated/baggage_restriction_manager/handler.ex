defmodule(Jaeger.Thrift.Generated.BaggageRestrictionManager.Handler) do
  @moduledoc(false)
  @callback(get_baggage_restrictions(service_name :: String.t()) :: [%Jaeger.Thrift.Generated.BaggageRestriction{}])
end