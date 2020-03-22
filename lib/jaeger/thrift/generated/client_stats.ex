defmodule(Jaeger.Thrift.Generated.ClientStats) do
  @moduledoc(false)
  _ = "Auto-generated Thrift struct jaeger.ClientStats"
  _ = "1: i64 full_queue_dropped_spans"
  _ = "2: i64 too_large_dropped_spans"
  _ = "3: i64 failed_to_emit_spans"
  defstruct(full_queue_dropped_spans: nil, too_large_dropped_spans: nil, failed_to_emit_spans: nil)
  @type(t :: %__MODULE__{})
  def(new) do
    %__MODULE__{}
  end
  defmodule(BinaryProtocol) do
    @moduledoc(false)
    def(deserialize(binary)) do
      deserialize(binary, %Jaeger.Thrift.Generated.ClientStats{})
    end
    defp(deserialize(<<0, rest::binary>>, %Jaeger.Thrift.Generated.ClientStats{} = acc)) do
      {acc, rest}
    end
    defp(deserialize(<<10, 1::16-signed, value::64-signed, rest::binary>>, acc)) do
      deserialize(rest, %{acc | full_queue_dropped_spans: value})
    end
    defp(deserialize(<<10, 2::16-signed, value::64-signed, rest::binary>>, acc)) do
      deserialize(rest, %{acc | too_large_dropped_spans: value})
    end
    defp(deserialize(<<10, 3::16-signed, value::64-signed, rest::binary>>, acc)) do
      deserialize(rest, %{acc | failed_to_emit_spans: value})
    end
    defp(deserialize(<<field_type, _id::16-signed, rest::binary>>, acc)) do
      rest |> Thrift.Protocol.Binary.skip_field(field_type) |> deserialize(acc)
    end
    defp(deserialize(_, _)) do
      :error
    end
    def(serialize(%Jaeger.Thrift.Generated.ClientStats{full_queue_dropped_spans: full_queue_dropped_spans, too_large_dropped_spans: too_large_dropped_spans, failed_to_emit_spans: failed_to_emit_spans})) do
      [case(full_queue_dropped_spans) do
        nil ->
          raise(Thrift.InvalidValueError, "Required field :full_queue_dropped_spans on Jaeger.Thrift.Generated.ClientStats must not be nil")
        _ ->
          <<10, 1::16-signed, full_queue_dropped_spans::64-signed>>
      end, case(too_large_dropped_spans) do
        nil ->
          raise(Thrift.InvalidValueError, "Required field :too_large_dropped_spans on Jaeger.Thrift.Generated.ClientStats must not be nil")
        _ ->
          <<10, 2::16-signed, too_large_dropped_spans::64-signed>>
      end, case(failed_to_emit_spans) do
        nil ->
          raise(Thrift.InvalidValueError, "Required field :failed_to_emit_spans on Jaeger.Thrift.Generated.ClientStats must not be nil")
        _ ->
          <<10, 3::16-signed, failed_to_emit_spans::64-signed>>
      end | <<0>>]
    end
  end
  def(serialize(struct)) do
    BinaryProtocol.serialize(struct)
  end
  def(serialize(struct, :binary)) do
    BinaryProtocol.serialize(struct)
  end
  def(deserialize(binary)) do
    BinaryProtocol.deserialize(binary)
  end
end