defmodule(Jaeger.Thrift.Generated.ValidateTraceResponse) do
  @moduledoc false
  _ = "Auto-generated Thrift struct aggregation_validator.ValidateTraceResponse"
  _ = "1: bool ok"
  _ = "2: i64 trace_count"
  defstruct(ok: nil, trace_count: nil)
  @type t :: %__MODULE__{}
  def(new) do
    %__MODULE__{}
  end

  defmodule(BinaryProtocol) do
    @moduledoc false
    def(deserialize(binary)) do
      deserialize(binary, %Jaeger.Thrift.Generated.ValidateTraceResponse{})
    end

    defp(
      deserialize(<<0, rest::binary>>, %Jaeger.Thrift.Generated.ValidateTraceResponse{} = acc)
    ) do
      {acc, rest}
    end

    defp(deserialize(<<2, 1::16-signed, 1, rest::binary>>, acc)) do
      deserialize(rest, %{acc | ok: true})
    end

    defp(deserialize(<<2, 1::16-signed, 0, rest::binary>>, acc)) do
      deserialize(rest, %{acc | ok: false})
    end

    defp(deserialize(<<10, 2::16-signed, value::64-signed, rest::binary>>, acc)) do
      deserialize(rest, %{acc | trace_count: value})
    end

    defp(deserialize(<<field_type, _id::16-signed, rest::binary>>, acc)) do
      rest |> Thrift.Protocol.Binary.skip_field(field_type) |> deserialize(acc)
    end

    defp(deserialize(_, _)) do
      :error
    end

    def(
      serialize(%Jaeger.Thrift.Generated.ValidateTraceResponse{ok: ok, trace_count: trace_count})
    ) do
      [
        case(ok) do
          false ->
            <<2, 1::16-signed, 0>>

          true ->
            <<2, 1::16-signed, 1>>

          _ ->
            raise(
              Thrift.InvalidValueError,
              "Required boolean field :ok on Jaeger.Thrift.Generated.ValidateTraceResponse must be true or false"
            )
        end,
        case(trace_count) do
          nil ->
            raise(
              Thrift.InvalidValueError,
              "Required field :trace_count on Jaeger.Thrift.Generated.ValidateTraceResponse must not be nil"
            )

          _ ->
            <<10, 2::16-signed, trace_count::64-signed>>
        end
        | <<0>>
      ]
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
