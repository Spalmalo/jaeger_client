defmodule(Jaeger.Thrift.Generated.DependencyLink) do
  @moduledoc false
  _ = "Auto-generated Thrift struct dependency.DependencyLink"
  _ = "1: string parent"
  _ = "2: string child"
  _ = "4: i64 call_count"
  defstruct(parent: nil, child: nil, call_count: nil)
  @type t :: %__MODULE__{}
  def(new) do
    %__MODULE__{}
  end

  defmodule(BinaryProtocol) do
    @moduledoc false
    def(deserialize(binary)) do
      deserialize(binary, %Jaeger.Thrift.Generated.DependencyLink{})
    end

    defp(deserialize(<<0, rest::binary>>, %Jaeger.Thrift.Generated.DependencyLink{} = acc)) do
      {acc, rest}
    end

    defp(
      deserialize(
        <<11, 1::16-signed, string_size::32-signed, value::binary-size(string_size),
          rest::binary>>,
        acc
      )
    ) do
      deserialize(rest, %{acc | parent: value})
    end

    defp(
      deserialize(
        <<11, 2::16-signed, string_size::32-signed, value::binary-size(string_size),
          rest::binary>>,
        acc
      )
    ) do
      deserialize(rest, %{acc | child: value})
    end

    defp(deserialize(<<10, 4::16-signed, value::64-signed, rest::binary>>, acc)) do
      deserialize(rest, %{acc | call_count: value})
    end

    defp(deserialize(<<field_type, _id::16-signed, rest::binary>>, acc)) do
      rest |> Thrift.Protocol.Binary.skip_field(field_type) |> deserialize(acc)
    end

    defp(deserialize(_, _)) do
      :error
    end

    def(
      serialize(%Jaeger.Thrift.Generated.DependencyLink{
        parent: parent,
        child: child,
        call_count: call_count
      })
    ) do
      [
        case(parent) do
          nil ->
            raise(
              Thrift.InvalidValueError,
              "Required field :parent on Jaeger.Thrift.Generated.DependencyLink must not be nil"
            )

          _ ->
            [<<11, 1::16-signed, byte_size(parent)::32-signed>> | parent]
        end,
        case(child) do
          nil ->
            raise(
              Thrift.InvalidValueError,
              "Required field :child on Jaeger.Thrift.Generated.DependencyLink must not be nil"
            )

          _ ->
            [<<11, 2::16-signed, byte_size(child)::32-signed>> | child]
        end,
        case(call_count) do
          nil ->
            raise(
              Thrift.InvalidValueError,
              "Required field :call_count on Jaeger.Thrift.Generated.DependencyLink must not be nil"
            )

          _ ->
            <<10, 4::16-signed, call_count::64-signed>>
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
