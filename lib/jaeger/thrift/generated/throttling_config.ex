defmodule(Jaeger.Thrift.Generated.ThrottlingConfig) do
  @moduledoc(false)
  _ = "Auto-generated Thrift struct throttling.ThrottlingConfig"
  _ = "1: i32 max_operations"
  _ = "2: double credits_per_second"
  _ = "3: double max_balance"
  defstruct(max_operations: nil, credits_per_second: nil, max_balance: nil)
  @type(t :: %__MODULE__{})
  def(new) do
    %__MODULE__{}
  end
  defmodule(BinaryProtocol) do
    @moduledoc(false)
    def(deserialize(binary)) do
      deserialize(binary, %Jaeger.Thrift.Generated.ThrottlingConfig{})
    end
    defp(deserialize(<<0, rest::binary>>, %Jaeger.Thrift.Generated.ThrottlingConfig{} = acc)) do
      {acc, rest}
    end
    defp(deserialize(<<8, 1::16-signed, value::32-signed, rest::binary>>, acc)) do
      deserialize(rest, %{acc | max_operations: value})
    end
    defp(deserialize(<<4, 2::16-signed, 0::1, 2047::11, 0::52, rest::binary>>, acc)) do
      deserialize(rest, %{acc | credits_per_second: :inf})
    end
    defp(deserialize(<<4, 2::16-signed, 1::1, 2047::11, 0::52, rest::binary>>, acc)) do
      deserialize(rest, %{acc | credits_per_second: :"-inf"})
    end
    defp(deserialize(<<4, 2::16-signed, sign::1, 2047::11, frac::52, rest::binary>>, acc)) do
      deserialize(rest, %{acc | credits_per_second: %Thrift.NaN{sign: sign, fraction: frac}})
    end
    defp(deserialize(<<4, 2::16-signed, value::float-signed, rest::binary>>, acc)) do
      deserialize(rest, %{acc | credits_per_second: value})
    end
    defp(deserialize(<<4, 3::16-signed, 0::1, 2047::11, 0::52, rest::binary>>, acc)) do
      deserialize(rest, %{acc | max_balance: :inf})
    end
    defp(deserialize(<<4, 3::16-signed, 1::1, 2047::11, 0::52, rest::binary>>, acc)) do
      deserialize(rest, %{acc | max_balance: :"-inf"})
    end
    defp(deserialize(<<4, 3::16-signed, sign::1, 2047::11, frac::52, rest::binary>>, acc)) do
      deserialize(rest, %{acc | max_balance: %Thrift.NaN{sign: sign, fraction: frac}})
    end
    defp(deserialize(<<4, 3::16-signed, value::float-signed, rest::binary>>, acc)) do
      deserialize(rest, %{acc | max_balance: value})
    end
    defp(deserialize(<<field_type, _id::16-signed, rest::binary>>, acc)) do
      rest |> Thrift.Protocol.Binary.skip_field(field_type) |> deserialize(acc)
    end
    defp(deserialize(_, _)) do
      :error
    end
    def(serialize(%Jaeger.Thrift.Generated.ThrottlingConfig{max_operations: max_operations, credits_per_second: credits_per_second, max_balance: max_balance})) do
      [case(max_operations) do
        nil ->
          raise(Thrift.InvalidValueError, "Required field :max_operations on Jaeger.Thrift.Generated.ThrottlingConfig must not be nil")
        _ ->
          <<8, 1::16-signed, max_operations::32-signed>>
      end, case(credits_per_second) do
        nil ->
          raise(Thrift.InvalidValueError, "Required field :credits_per_second on Jaeger.Thrift.Generated.ThrottlingConfig must not be nil")
        _ ->
          [<<4, 2::16-signed>> | case(credits_per_second) do
            :inf ->
              <<0::1, 2047::11, 0::52>>
            :"-inf" ->
              <<1::1, 2047::11, 0::52>>
            %Thrift.NaN{sign: sign, fraction: frac} ->
              <<sign::1, 2047::11, frac::52>>
            _ ->
              <<credits_per_second::float-signed>>
          end]
      end, case(max_balance) do
        nil ->
          raise(Thrift.InvalidValueError, "Required field :max_balance on Jaeger.Thrift.Generated.ThrottlingConfig must not be nil")
        _ ->
          [<<4, 3::16-signed>> | case(max_balance) do
            :inf ->
              <<0::1, 2047::11, 0::52>>
            :"-inf" ->
              <<1::1, 2047::11, 0::52>>
            %Thrift.NaN{sign: sign, fraction: frac} ->
              <<sign::1, 2047::11, frac::52>>
            _ ->
              <<max_balance::float-signed>>
          end]
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