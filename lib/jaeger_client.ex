defmodule JaegerClient do
  @moduledoc """
  Documentation for JaegerClient.
  """

  @typedoc """
  Represents unique 128bit identifier of a trace.
  """
  @type trace_id :: {pos_integer, pos_integer}

  @typedoc """
  Represents unique 64bit identifier of a span
  """
  @type span_id :: pos_integer
end
