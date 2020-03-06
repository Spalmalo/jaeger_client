defmodule(Jaeger.Thrift.Generated.SamplingManager) do
  @moduledoc false
  defmodule(GetSamplingStrategyArgs) do
    @moduledoc false
    _ = "Auto-generated Thrift struct Elixir.GetSamplingStrategyArgs"
    _ = "1: string service_name"
    defstruct(service_name: nil)
    @type t :: %__MODULE__{}
    def(new) do
      %__MODULE__{}
    end

    defmodule(BinaryProtocol) do
      @moduledoc false
      def(deserialize(binary)) do
        deserialize(binary, %GetSamplingStrategyArgs{})
      end

      defp(deserialize(<<0, rest::binary>>, %GetSamplingStrategyArgs{} = acc)) do
        {acc, rest}
      end

      defp(
        deserialize(
          <<11, 1::16-signed, string_size::32-signed, value::binary-size(string_size),
            rest::binary>>,
          acc
        )
      ) do
        deserialize(rest, %{acc | service_name: value})
      end

      defp(deserialize(<<field_type, _id::16-signed, rest::binary>>, acc)) do
        rest |> Thrift.Protocol.Binary.skip_field(field_type) |> deserialize(acc)
      end

      defp(deserialize(_, _)) do
        :error
      end

      def(serialize(%GetSamplingStrategyArgs{service_name: service_name})) do
        [
          case(service_name) do
            nil ->
              <<>>

            _ ->
              [<<11, 1::16-signed, byte_size(service_name)::32-signed>> | service_name]
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

  defmodule(GetSamplingStrategyResponse) do
    @moduledoc false
    _ = "Auto-generated Thrift struct Elixir.GetSamplingStrategyResponse"
    _ = "0: sampling.SamplingStrategyResponse success"
    defstruct(success: nil)
    @type t :: %__MODULE__{}
    def(new) do
      %__MODULE__{}
    end

    defmodule(BinaryProtocol) do
      @moduledoc false
      def(deserialize(binary)) do
        deserialize(binary, %GetSamplingStrategyResponse{})
      end

      defp(deserialize(<<0, rest::binary>>, %GetSamplingStrategyResponse{} = acc)) do
        {acc, rest}
      end

      defp(deserialize(<<12, 0::16-signed, rest::binary>>, acc)) do
        case(
          Elixir.Jaeger.Thrift.Generated.SamplingStrategyResponse.BinaryProtocol.deserialize(rest)
        ) do
          {value, rest} ->
            deserialize(rest, %{acc | success: value})

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

      def(serialize(%GetSamplingStrategyResponse{success: success})) do
        [
          case(success) do
            nil ->
              <<>>

            _ ->
              [
                <<12, 0::16-signed>>
                | Jaeger.Thrift.Generated.SamplingStrategyResponse.serialize(success)
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

  defmodule(Binary.Framed.Client) do
    @moduledoc false
    alias(Thrift.Binary.Framed.Client, as: ClientImpl)
    defdelegate(close(conn), to: ClientImpl)
    defdelegate(connect(conn, opts), to: ClientImpl)
    defdelegate(start_link(host, port, opts \\ []), to: ClientImpl)

    def(unquote(:get_sampling_strategy)(client, service_name, rpc_opts \\ [])) do
      args = %GetSamplingStrategyArgs{service_name: service_name}
      serialized_args = GetSamplingStrategyArgs.BinaryProtocol.serialize(args)

      ClientImpl.call(
        client,
        "getSamplingStrategy",
        serialized_args,
        GetSamplingStrategyResponse.BinaryProtocol,
        rpc_opts
      )
    end

    def(unquote(:get_sampling_strategy!)(client, service_name, rpc_opts \\ [])) do
      case(unquote(:get_sampling_strategy)(client, service_name, rpc_opts)) do
        {:ok, rsp} ->
          rsp

        {:error, {:exception, ex}} ->
          raise(ex)

        {:error, reason} ->
          raise(Thrift.ConnectionError, reason: reason)
      end
    end
  end

  defmodule(Binary.Framed.Server) do
    @moduledoc false
    require(Logger)
    alias(Thrift.Binary.Framed.Server, as: ServerImpl)
    defdelegate(stop(name), to: ServerImpl)

    def(start_link(handler_module, port, opts \\ [])) do
      ServerImpl.start_link(__MODULE__, port, handler_module, opts)
    end

    def(handle_thrift("getSamplingStrategy", binary_data, handler_module)) do
      case(
        Elixir.Jaeger.Thrift.Generated.SamplingManager.GetSamplingStrategyArgs.BinaryProtocol.deserialize(
          binary_data
        )
      ) do
        {%Jaeger.Thrift.Generated.SamplingManager.GetSamplingStrategyArgs{
           service_name: service_name
         }, ""} ->
          try do
            rsp = handler_module.get_sampling_strategy(service_name)

            (
              response = %Jaeger.Thrift.Generated.SamplingManager.GetSamplingStrategyResponse{
                success: rsp
              }

              {:reply,
               Elixir.Jaeger.Thrift.Generated.SamplingManager.GetSamplingStrategyResponse.BinaryProtocol.serialize(
                 response
               )}
            )
          rescue
            []
          catch
            kind, reason ->
              formatted_exception = Exception.format(kind, reason, System.stacktrace())

              Logger.error(
                "Exception not defined in thrift spec was thrown: #{formatted_exception}"
              )

              error =
                Thrift.TApplicationException.exception(
                  type: :internal_error,
                  message: "Server error: #{formatted_exception}"
                )

              {:server_error, error}
          end

        {_, extra} ->
          raise(Thrift.TApplicationException,
            type: :protocol_error,
            message: "Could not decode #{inspect(extra)}"
          )
      end
    end
  end
end
