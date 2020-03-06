defmodule(Jaeger.Thrift.Generated.Dependencies) do
  @moduledoc false
  _ = "Auto-generated Thrift struct dependency.Dependencies"
  _ = "1: list<dependency.DependencyLink> links"
  defstruct(links: nil)
  @type t :: %__MODULE__{}
  def(new) do
    %__MODULE__{}
  end

  defmodule(BinaryProtocol) do
    @moduledoc false
    def(deserialize(binary)) do
      deserialize(binary, %Jaeger.Thrift.Generated.Dependencies{})
    end

    defp(deserialize(<<0, rest::binary>>, %Jaeger.Thrift.Generated.Dependencies{} = acc)) do
      {acc, rest}
    end

    defp(deserialize(<<15, 1::16-signed, 12, remaining::32-signed, rest::binary>>, struct)) do
      deserialize__links(rest, [[], remaining, struct])
    end

    defp(deserialize(<<field_type, _id::16-signed, rest::binary>>, acc)) do
      rest |> Thrift.Protocol.Binary.skip_field(field_type) |> deserialize(acc)
    end

    defp(deserialize(_, _)) do
      :error
    end

    defp(deserialize__links(<<rest::binary>>, [list, 0, struct])) do
      deserialize(rest, %{struct | links: Enum.reverse(list)})
    end

    defp(deserialize__links(<<rest::binary>>, [list, remaining | stack])) do
      case(Elixir.Jaeger.Thrift.Generated.DependencyLink.BinaryProtocol.deserialize(rest)) do
        {element, rest} ->
          deserialize__links(rest, [[element | list], remaining - 1 | stack])

        :error ->
          :error
      end
    end

    defp(deserialize__links(_, _)) do
      :error
    end

    def(serialize(%Jaeger.Thrift.Generated.Dependencies{links: links})) do
      [
        case(links) do
          nil ->
            raise(
              Thrift.InvalidValueError,
              "Required field :links on Jaeger.Thrift.Generated.Dependencies must not be nil"
            )

          _ ->
            [
              <<15, 1::16-signed, 12, length(links)::32-signed>>
              | for(e <- links) do
                  Jaeger.Thrift.Generated.DependencyLink.serialize(e)
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
