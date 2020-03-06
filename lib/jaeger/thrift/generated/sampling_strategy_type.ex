defmodule(Jaeger.Thrift.Generated.SamplingStrategyType) do
  @moduledoc false
  defmacro(unquote(:probabilistic)()) do
    0
  end

  defmacro(unquote(:rate_limiting)()) do
    1
  end

  def(value_to_name(0)) do
    {:ok, :probabilistic}
  end

  def(value_to_name(1)) do
    {:ok, :rate_limiting}
  end

  def(value_to_name(v)) do
    {:error, {:invalid_enum_value, v}}
  end

  def(name_to_value(:probabilistic)) do
    {:ok, 0}
  end

  def(name_to_value(:rate_limiting)) do
    {:ok, 1}
  end

  def(name_to_value(k)) do
    {:error, {:invalid_enum_name, k}}
  end

  def(value_to_name!(value)) do
    {:ok, name} = value_to_name(value)
    name
  end

  def(name_to_value!(name)) do
    {:ok, value} = name_to_value(name)
    value
  end

  def(meta(:names)) do
    [:probabilistic, :rate_limiting]
  end

  def(meta(:values)) do
    [0, 1]
  end

  def(member?(0)) do
    true
  end

  def(member?(1)) do
    true
  end

  def(member?(_)) do
    false
  end

  def(name?(:probabilistic)) do
    true
  end

  def(name?(:rate_limiting)) do
    true
  end

  def(name?(_)) do
    false
  end
end
