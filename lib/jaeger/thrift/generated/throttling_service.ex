defmodule(Jaeger.Thrift.Generated.ThrottlingService) do
  @moduledoc false
  defmodule(GetThrottlingConfigsArgs) do
    @moduledoc false
    _ = "Auto-generated Thrift struct Elixir.GetThrottlingConfigsArgs"
    _ = "1: list<string> service_names"
    defstruct(service_names: nil)
    @type t :: %__MODULE__{}
    def(new) do
      %__MODULE__{}
    end

    defmodule(BinaryProtocol) do
      @moduledoc false
      def(deserialize(binary)) do
        deserialize(binary, %GetThrottlingConfigsArgs{})
      end

      defp(deserialize(<<0, rest::binary>>, %GetThrottlingConfigsArgs{} = acc)) do
        {acc, rest}
      end

      defp(deserialize(<<15, 1::16-signed, 11, remaining::32-signed, rest::binary>>, struct)) do
        deserialize__service_names(rest, [[], remaining, struct])
      end

      defp(deserialize(<<field_type, _id::16-signed, rest::binary>>, acc)) do
        rest |> Thrift.Protocol.Binary.skip_field(field_type) |> deserialize(acc)
      end

      defp(deserialize(_, _)) do
        :error
      end

      defp(deserialize__service_names(<<rest::binary>>, [list, 0, struct])) do
        deserialize(rest, %{struct | service_names: Enum.reverse(list)})
      end

      defp(
        deserialize__service_names(
          <<string_size::32-signed, element::binary-size(string_size), rest::binary>>,
          [list, remaining | stack]
        )
      ) do
        deserialize__service_names(rest, [[element | list], remaining - 1 | stack])
      end

      defp(deserialize__service_names(_, _)) do
        :error
      end

      def(serialize(%GetThrottlingConfigsArgs{service_names: service_names})) do
        [
          case(service_names) do
            nil ->
              <<>>

            _ ->
              [
                <<15, 1::16-signed, 11, length(service_names)::32-signed>>
                | for(e <- service_names) do
                    [<<byte_size(e)::32-signed>> | e]
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

  defmodule(GetThrottlingConfigsResponse) do
    @moduledoc false
    _ = "Auto-generated Thrift struct Elixir.GetThrottlingConfigsResponse"
    _ = "0: throttling.ThrottlingResponse success"
    defstruct(success: nil)
    @type t :: %__MODULE__{}
    def(new) do
      %__MODULE__{}
    end

    defmodule(BinaryProtocol) do
      @moduledoc false
      def(deserialize(binary)) do
        deserialize(binary, %GetThrottlingConfigsResponse{})
      end

      defp(deserialize(<<0, rest::binary>>, %GetThrottlingConfigsResponse{} = acc)) do
        {acc, rest}
      end

      defp(deserialize(<<12, 0::16-signed, rest::binary>>, acc)) do
        case(
          Elixir.Jaeger.Thrift.Generated.ThrottlingResponse.BinaryProtocol.deserialize(rest)
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

      def(serialize(%GetThrottlingConfigsResponse{success: success})) do
        [
          case(success) do
            nil ->
              <<>>

            _ ->
              [
                <<12, 0::16-signed>>
                | Jaeger.Thrift.Generated.ThrottlingResponse.serialize(success)
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

    def(unquote(:get_throttling_configs)(client, service_names, rpc_opts \\ [])) do
      args = %GetThrottlingConfigsArgs{service_names: service_names}
      serialized_args = GetThrottlingConfigsArgs.BinaryProtocol.serialize(args)

      ClientImpl.call(
        client,
        "getThrottlingConfigs",
        serialized_args,
        GetThrottlingConfigsResponse.BinaryProtocol,
        rpc_opts
      )
    end

    def(unquote(:get_throttling_configs!)(client, service_names, rpc_opts \\ [])) do
      case(unquote(:get_throttling_configs)(client, service_names, rpc_opts)) do
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

    def(handle_thrift("getThrottlingConfigs", binary_data, handler_module)) do
      case(
        Elixir.Jaeger.Thrift.Generated.ThrottlingService.GetThrottlingConfigsArgs.BinaryProtocol.deserialize(
          binary_data
        )
      ) do
        {%Jaeger.Thrift.Generated.ThrottlingService.GetThrottlingConfigsArgs{
           service_names: service_names
         }, ""} ->
          try do
            rsp = handler_module.get_throttling_configs(service_names)

            (
              response = %Jaeger.Thrift.Generated.ThrottlingService.GetThrottlingConfigsResponse{
                success: rsp
              }

              {:reply,
               Elixir.Jaeger.Thrift.Generated.ThrottlingService.GetThrottlingConfigsResponse.BinaryProtocol.serialize(
                 response
               )}
            )
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
