defmodule(Jaeger.Thrift.Generated.ProbabilisticSamplingStrategy) do
  @moduledoc false
  _ = "Auto-generated Thrift struct sampling.ProbabilisticSamplingStrategy"
  _ = "1: double sampling_rate"
  defstruct(sampling_rate: nil)
  @type t :: %__MODULE__{}
  def(new) do
    %__MODULE__{}
  end

  defmodule(BinaryProtocol) do
    @moduledoc false
    def(deserialize(binary)) do
      deserialize(binary, %Jaeger.Thrift.Generated.ProbabilisticSamplingStrategy{})
    end

    defp(
      deserialize(
        <<0, rest::binary>>,
        %Jaeger.Thrift.Generated.ProbabilisticSamplingStrategy{} = acc
      )
    ) do
      {acc, rest}
    end

    defp(deserialize(<<4, 1::16-signed, 0::1, 2047::11, 0::52, rest::binary>>, acc)) do
      deserialize(rest, %{acc | sampling_rate: :inf})
    end

    defp(deserialize(<<4, 1::16-signed, 1::1, 2047::11, 0::52, rest::binary>>, acc)) do
      deserialize(rest, %{acc | sampling_rate: :"-inf"})
    end

    defp(deserialize(<<4, 1::16-signed, sign::1, 2047::11, frac::52, rest::binary>>, acc)) do
      deserialize(rest, %{acc | sampling_rate: %Thrift.NaN{sign: sign, fraction: frac}})
    end

    defp(deserialize(<<4, 1::16-signed, value::float-signed, rest::binary>>, acc)) do
      deserialize(rest, %{acc | sampling_rate: value})
    end

    defp(deserialize(<<field_type, _id::16-signed, rest::binary>>, acc)) do
      rest |> Thrift.Protocol.Binary.skip_field(field_type) |> deserialize(acc)
    end

    defp(deserialize(_, _)) do
      :error
    end

    def(
      serialize(%Jaeger.Thrift.Generated.ProbabilisticSamplingStrategy{
        sampling_rate: sampling_rate
      })
    ) do
      [
        case(sampling_rate) do
          nil ->
            raise(
              Thrift.InvalidValueError,
              "Required field :sampling_rate on Jaeger.Thrift.Generated.ProbabilisticSamplingStrategy must not be nil"
            )

          _ ->
            [
              <<4, 1::16-signed>>
              | case(sampling_rate) do
                  :inf ->
                    <<0::1, 2047::11, 0::52>>

                  :"-inf" ->
                    <<1::1, 2047::11, 0::52>>

                  %Thrift.NaN{sign: sign, fraction: frac} ->
                    <<sign::1, 2047::11, frac::52>>

                  _ ->
                    <<sampling_rate::float-signed>>
                end
            ]
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
