defmodule(Jaeger.Thrift.Generated.ServiceThrottlingConfig) do
  @moduledoc(false)
  _ = "Auto-generated Thrift struct throttling.ServiceThrottlingConfig"
  _ = "1: string service_name"
  _ = "2: throttling.ThrottlingConfig config"
  defstruct(service_name: nil, config: nil)
  @type(t :: %__MODULE__{})
  def(new) do
    %__MODULE__{}
  end
  defmodule(BinaryProtocol) do
    @moduledoc(false)
    def(deserialize(binary)) do
      deserialize(binary, %Jaeger.Thrift.Generated.ServiceThrottlingConfig{})
    end
    defp(deserialize(<<0, rest::binary>>, %Jaeger.Thrift.Generated.ServiceThrottlingConfig{} = acc)) do
      {acc, rest}
    end
    defp(deserialize(<<11, 1::16-signed, string_size::32-signed, value::binary-size(string_size), rest::binary>>, acc)) do
      deserialize(rest, %{acc | service_name: value})
    end
    defp(deserialize(<<12, 2::16-signed, rest::binary>>, acc)) do
      case(Elixir.Jaeger.Thrift.Generated.ThrottlingConfig.BinaryProtocol.deserialize(rest)) do
        {value, rest} ->
          deserialize(rest, %{acc | config: value})
        :error ->
          :error
      end
    end
    defp(deserialize(<<field_type, _id::16-signed, rest::binary>>, acc)) do
      rest |> Thrift.Protocol.Binary.skip_field(field_type) |> deserialize(acc)
    end
    defp(deserialize(_, _)) do
      :error
    end
    def(serialize(%Jaeger.Thrift.Generated.ServiceThrottlingConfig{service_name: service_name, config: config})) do
      [case(service_name) do
        nil ->
          raise(Thrift.InvalidValueError, "Required field :service_name on Jaeger.Thrift.Generated.ServiceThrottlingConfig must not be nil")
        _ ->
          [<<11, 1::16-signed, byte_size(service_name)::32-signed>> | service_name]
      end, case(config) do
        nil ->
          raise(Thrift.InvalidValueError, "Required field :config on Jaeger.Thrift.Generated.ServiceThrottlingConfig must not be nil")
        _ ->
          [<<12, 2::16-signed>> | Jaeger.Thrift.Generated.ThrottlingConfig.serialize(config)]
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